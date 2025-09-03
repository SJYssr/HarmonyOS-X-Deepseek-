import ChatPage from './ChatPage'
import SettingsPage from './SettingsPage'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() {
        ChatPage()
      }
      .tabBar({
        icon: $r('app.media.startIcon'),
        text: '聊天'
      })

      TabContent() {
        SettingsPage()
      }
      .tabBar({
        icon: $r('app.media.startIcon'),
        text: '设置'
      })
    }
    .height('100%')
    .width('100%')
  }
}