import SettingsService, { getSettingsContext } from '../services/SettingsService'
import { Want } from '@kit.AbilityKit'
import { ModelType } from '../types/AiTypes'

@Component
export default struct SettingsPage {
  @State apiKey: string = SettingsService.getApiKey()
  @State model: ModelType = SettingsService.getModel()
  @State saved: boolean = false

  private save() {
    SettingsService.setApiKey(this.apiKey)
    SettingsService.setModel(this.model)
    this.saved = true
    setTimeout(() => this.saved = false, 1500)
  }

  private openLink(url: string) {
    try {
      const want: Want = { action: 'ohos.want.action.viewData', uri: url } as Want
      const ctx = getSettingsContext()
      ctx?.startAbility(want).catch(() => {})
    } catch (_) {}
  }

  build() {
    Column() {
      Text('DeepSeek 设置')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 })

      Text('API Key')
        .margin({ bottom: 6 })
      TextInput({ placeholder: '输入你的 DeepSeek API Key', text: this.apiKey })
        .type(InputType.Password)
        .onChange(v => this.apiKey = v)
        .margin({ bottom: 16 })

      Text('模型')
        .margin({ bottom: 6 })
      Column() {
        Row() {
          Radio({ value: 'deepseek-chat', group: 'model' })
            .checked(this.model === 'deepseek-chat')
            .onChange((checked: boolean) => { if (checked) this.model = 'deepseek-chat' })
          Text('deepseek-chat（非深度思考）')
        }
        .margin({ bottom: 8 })

        Row() {
          Radio({ value: 'deepseek-reasoner', group: 'model' })
            .checked(this.model === 'deepseek-reasoner')
            .onChange((checked: boolean) => { if (checked) this.model = 'deepseek-reasoner' })
          Text('deepseek-reasoner（深度思考）')
        }
      }
      .margin({ bottom: 24 })

      Button(this.saved ? '已保存' : '保存设置')
        .type(ButtonType.Capsule)
        .onClick(() => this.save())
        .enabled(!!this.apiKey && !!this.model)

      Row() {
        Text('powered by ')
        Text('sjyssr')
          .fontColor(Color.Blue)
          .decoration({ type: TextDecorationType.Underline })
          .onClick(() => this.openLink('http://sjyssr.net'))
      }
      .justifyContent(FlexAlign.Center)
      .margin({ top: 24 })
    }
    .padding(16)
    .height('100%')
    .width('100%')
  }
}


