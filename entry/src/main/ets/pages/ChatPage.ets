import DeepSeekService from '../services/DeepSeekService'
import SettingsService from '../services/SettingsService'
import { ModelType, ChatMessage } from '../types/AiTypes'

@Component
export default struct ChatPage {
  @State userInput: string = ''
  @State messages: Array<ChatMessage> = []
  @State loading: boolean = false
  @State errorText: string = ''
  @State status: 'idle' | 'loading' | 'generating' | 'done' | 'error' = 'idle'
  @State displayText: string = ''
  private timerId: number = 0

  aboutToAppear() {
    const apiKey = SettingsService.getApiKey()
    if (!apiKey) {
      this.errorText = '请先在设置中配置 API Key'
    }
  }

  private cancelTimer() {
    if (this.timerId) {
      clearTimeout(this.timerId)
      this.timerId = 0
    }
  }

  private startTypingAnimation(source: string) {
    this.status = 'generating'
    this.displayText = ''
    this.cancelTimer()
    let index: number = 0
    const total: number = source.length
    const stepMs: number = 100
    const tick = () => {
      if (index < total) {
        this.displayText += source.charAt(index)
        index++
        this.timerId = setTimeout(tick, stepMs) as number
      } else {
        this.cancelTimer()
        this.status = 'done'
        const assistantMsg: ChatMessage = { role: 'assistant', content: source }
        this.messages = [...this.messages, assistantMsg]
        this.displayText = ''
      }
    }
    this.timerId = setTimeout(tick, stepMs) as number
  }

  aboutToDisappear() {
    this.cancelTimer()
  }

  private async sendMessage() {
    if (!this.userInput || this.loading) {
      return
    }

    const apiKey: string = SettingsService.getApiKey()
    const model: ModelType = SettingsService.getModel()
    if (!apiKey) {
      this.errorText = '请先在设置中配置 API Key'
      return
    }

    this.errorText = ''
    const content: string = this.userInput
    this.userInput = ''
    const newUserMsg: ChatMessage = { role: 'user', content: content }
    this.messages = [...this.messages, newUserMsg]
    this.loading = true
    this.status = 'loading'
    try {
      const reply: string = await DeepSeekService.createChatCompletion({
        apiKey,
        model,
        messages: this.messages
      })
      this.startTypingAnimation(reply)
    } catch (e) {
      const errMsg: string = (e && (e as Error).message) ? (e as Error).message : `${e}`
      this.errorText = errMsg
      this.status = 'error'
    } finally {
      this.loading = false
    }
  }

  build() {
    Column() {
      if (this.errorText) {
        Text(this.errorText)
          .fontColor(Color.Red)
          .margin({ bottom: 8 })
      }

      List() {
        ForEach(this.messages, (msg: ChatMessage, idx: number) => {
          ListItem() {
            Column() {
              Text(msg.role === 'user' ? '' : 'DeepSeek')
                .fontWeight(FontWeight.Bold)
                .fontColor($r('app.color.text_primary'))
                .margin({ bottom: 4 })
              Text(msg.content)
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
                .textAlign(TextAlign.Start)
            }
            .padding(12)
            .backgroundColor(msg.role === 'user' ? $r('app.color.bubble_user') : $r('app.color.bubble_ai'))
            .borderRadius(8)
          }
          .padding({ left: 12, right: 12, top: 6, bottom: 6 })
          .align(Alignment.Start)
        })
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.background'))

      Row() {
        TextInput({ placeholder: '输入你的问题...', text: this.userInput })
          .layoutWeight(1)
          .onChange((v: string) => this.userInput = v)
          .enableKeyboardOnFocus(true)
          .margin({ right: 8 })
          .onSubmit(() => this.sendMessage())
        Button(this.loading ? '发送中...' : '发送')
          .type(ButtonType.Capsule)
          .onClick(() => this.sendMessage())
          .enabled(!this.loading)
      }
      .padding(12)
      .backgroundColor($r('app.color.divider'))
    }
    .height('100%')
    .width('100%')
  }
}


