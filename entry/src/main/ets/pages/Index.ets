// 在struct外部定义Record接口
interface TimerRecord {
  id: number;
  duration: number;
  actualTime: number;
  endTime: string;
  isCompleted: boolean;
}

@Entry
@Component
struct Index {
  // 计时器状态
  @State selectedTime: number = 180; // 默认3分钟
  @State remainingTime: number = 180;
  @State isRunning: boolean = false;
  @State timerId: number = 0;

  // 记录数组 - 这里要使用TimerRecord接口
  @State records: TimerRecord[] = [];

  // 时间选项
  timeOptions: number[] = [60, 180, 300, 600, 900];

  // 格式化时间
  formatTime(seconds: number): string {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }

  // 开始计时
  startTimer() {
    if (this.isRunning) return;

    this.isRunning = true;
    this.remainingTime = this.selectedTime;

    this.timerId = setInterval(() => {
      if (this.remainingTime > 0) {
        this.remainingTime--;
      } else {
        this.stopTimer(true); // 自然结束
      }
    }, 1000);
  }

  // 停止计时
  stopTimer(isCompleted: boolean) {
    if (!this.isRunning) return;

    clearInterval(this.timerId);
    this.isRunning = false;

    // 创建记录
    const actualTime = this.selectedTime - this.remainingTime;
    const record:  TimerRecord= {
      id: Date.now(),
      duration: this.selectedTime,
      actualTime: actualTime,
      endTime: new Date().toLocaleTimeString(),
      isCompleted: isCompleted
    };

    // 添加到记录列表
    this.records = [record, ...this.records];

    // 重置倒计时
    this.remainingTime = this.selectedTime;
  }

  build() {
    Column({ space: 20 }) {
      // 标题
      Text('专注计时器')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 40 })

      // 倒计时显示
      Text(this.formatTime(this.remainingTime))
        .fontSize(60)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.isRunning ? '#007DFF' : '#000000')
        .margin({ top: 30, bottom: 20 })

      // 控制按钮
      if (!this.isRunning) {
        Button('开始计时', { type: ButtonType.Capsule })
          .width(150)
          .height(45)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .onClick(() => this.startTimer())
      } else {
        Button('停止', { type: ButtonType.Capsule })
          .width(150)
          .height(45)
          .backgroundColor('#FF0000')
          .fontColor(Color.White)
          .onClick(() => this.stopTimer(false))
      }

      // 时间选择
      Text('选择时间：')
        .fontSize(18)
        .margin({ top: 20 })

      Row({ space: 10 }) {
        ForEach(this.timeOptions, (time: number) => {
          Button(this.formatTime(time), { type: ButtonType.Normal })
            .width(70)
            .height(35)
            .backgroundColor(this.selectedTime === time ? '#007DFF' : '#F2F2F2')
            .fontColor(this.selectedTime === time ? Color.White : '#000000')
            .enabled(!this.isRunning)
            .onClick(() => {
              if (!this.isRunning) {
                this.selectedTime = time;
                this.remainingTime = time;
              }
            })
        })
      }

      .margin({ bottom: 20 })

      // 记录列表
      Text('计时记录：')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin({ top: 20 })

      if (this.records.length > 0) {
        List({ space: 10 }) {
          ForEach(this.records, (record:TimerRecord) => {
            ListItem() {
              Column({ space: 5 }) {
                Text(`计划:${this.formatTime(record.duration)} 实际:${this.formatTime(record.actualTime)}`)
                  .fontSize(16)
                Text(record.isCompleted ? '✅ 完成' : '⏸️ 中断')
                  .fontSize(14)
                  .fontColor(record.isCompleted ? '#00CC00' : '#FF9900')
                Text(`结束: ${record.endTime}`)
                  .fontSize(12)
                  .fontColor('#666666')
              }
              .padding(15)
              .width('100%')
              .backgroundColor('#F8F8F8')
              .borderRadius(10)
            }
          })
        }
        .height(250)
        .width('90%')
      } else {
        Text('暂无记录')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 30 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .padding(10)
  }
}