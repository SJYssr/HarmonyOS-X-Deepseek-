import http from '@ohos.net.http'
import { ModelType, ChatMessage, ChatCompletionResponse, HttpHeaders, ChatRequestBody } from '../types/AiTypes'

interface CreateChatCompletionParams {
  apiKey: string
  model: ModelType
  messages: Array<ChatMessage>
}

class DeepSeekServiceImpl {
  private readonly baseUrl: string = 'https://api.deepseek.com'

  async createChatCompletion(params: CreateChatCompletionParams): Promise<string> {
    const client = http.createHttp()
    try {
      const url = `${this.baseUrl}/chat/completions`
      const body: ChatRequestBody = {
        model: params.model,
        messages: params.messages
      }
      const headers: HttpHeaders = {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${params.apiKey}`
      }

      const res = await client.request(url, {
        method: http.RequestMethod.POST,
        header: headers,
        extraData: JSON.stringify(body),
        expectDataType: http.HttpDataType.STRING,
        usingProtocol: http.HttpProtocol.HTTP1_1,
        readTimeout: 30000,
        connectTimeout: 15000
      })

      if (res.responseCode < 200 || res.responseCode >= 300) {
        throw new Error(`HTTP ${res.responseCode}: ${res.result}`)
      }

      const data: ChatCompletionResponse = JSON.parse(res.result as string)
      const content: string = (data && data.choices && data.choices[0] && data.choices[0].message && data.choices[0].message.content) ? data.choices[0].message.content : ''
      if (!content) {
        throw new Error('响应为空')
      }
      return content
    } finally {
      client.destroy()
    }
  }
}

const DeepSeekService = new DeepSeekServiceImpl()
export default DeepSeekService


