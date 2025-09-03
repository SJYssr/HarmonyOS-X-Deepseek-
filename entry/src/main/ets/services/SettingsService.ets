import preferences from '@ohos.data.preferences'
import { BusinessError } from '@ohos.base'
import { ModelType } from '../types/AiTypes'
import common from '@ohos.app.ability.common'

class SettingsServiceImpl {
  private readonly storageName: string = 'deepseek_settings'
  private readonly apiKeyKey: string = 'api_key'
  private readonly modelKey: string = 'model'
  private cachedApiKey: string = ''
  private cachedModel: ModelType = 'deepseek-chat'

  private static abilityCtx: common.UIAbilityContext | null = null

  static setAbilityContext(ctx: common.UIAbilityContext): void {
    SettingsServiceImpl.abilityCtx = ctx
  }

  static getAbilityContext(): common.UIAbilityContext | null {
    return SettingsServiceImpl.abilityCtx
  }

  private async getPrefs() {
    try {
      const ctx = SettingsServiceImpl.abilityCtx as common.UIAbilityContext
      const helper = await preferences.getPreferences(ctx, this.storageName)
      return helper
    } catch (err) {
      const e = err as BusinessError
      throw new Error(`无法打开偏好存储: ${e?.message ?? err}`)
    }
  }

  getApiKey(): string {
    return this.cachedApiKey
  }

  getModel(): ModelType {
    return this.cachedModel
  }

  async load(): Promise<void> {
    const prefs = await this.getPrefs()
    this.cachedApiKey = (await prefs.get(this.apiKeyKey, '')) as string
    this.cachedModel = (await prefs.get(this.modelKey, 'deepseek-chat')) as ModelType
  }

  async save(): Promise<void> {
    const prefs = await this.getPrefs()
    await prefs.put(this.apiKeyKey, this.cachedApiKey)
    await prefs.put(this.modelKey, this.cachedModel)
    await prefs.flush()
  }

  setApiKey(value: string) {
    this.cachedApiKey = value
    this.save()
  }

  setModel(value: ModelType) {
    this.cachedModel = value
    this.save()
  }
}

const SettingsService = new SettingsServiceImpl()
export default SettingsService

export function initSettingsContext(ctx: common.UIAbilityContext): void {
  SettingsServiceImpl.setAbilityContext(ctx)
}

export function getSettingsContext(): common.UIAbilityContext | null {
  return SettingsServiceImpl.getAbilityContext()
}


