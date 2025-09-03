export type ModelType = 'deepseek-chat' | 'deepseek-reasoner'

export interface ChatMessage {
  role: 'system' | 'user' | 'assistant'
  content: string
}

export interface ChatCompletionChoice {
  message: ChatMessage
}

export interface ChatCompletionResponse {
  choices: ChatCompletionChoice[]
}

export interface HttpHeaders {
  'Content-Type': string
  'Authorization': string
}

export interface ChatRequestBody {
  model: ModelType
  messages: ChatMessage[]
}


