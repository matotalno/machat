# Modern AI Chat - OpenAI API Reference

## Core Chat Functionality

### Chat Completions
```python
# Kreiranje chat completion-a
client.chat.completions.create(**params) -> ChatCompletion

# Parametri
interface ChatParams {
    model: string,          # "gpt-3.5-turbo" ili "gpt-4"
    messages: Message[],    # Niz poruka
    temperature: float,     # 0.0 - 2.0
    stream: boolean,        # Za streaming response
    max_tokens: int,        # Maksimalan broj tokena
}

# Response struktura
interface ChatCompletion {
    id: string
    choices: [
        {
            message: {
                role: string,
                content: string
            }
        }
    ]
    usage: {
        total_tokens: int,
        completion_tokens: int,
        prompt_tokens: int
    }
}
```

### Streaming Implementation
```python
# Streaming chat completion
async for chunk in client.chat.completions.create(
    model="gpt-3.5-turbo",
    messages=[{"role": "user", "content": "Hello"}],
    stream=True
):
    if chunk.choices[0].delta.content:
        content = chunk.choices[0].delta.content
        # Process streamed content
```

## Models & Settings

### Model Selection
```python
# Dostupni modeli
client.models.list()

# Model parametri
interface ModelParams {
    temperature: float,     # 0.0 - 2.0
    top_p: float,          # 0.0 - 1.0
    frequency_penalty: float,
    presence_penalty: float
}
```

## Error Handling

### Common Error Codes
```python
401: "Invalid Authentication"
408: "Request Timeout"
429: "Rate limit reached"
500: "Internal Server Error"
```

### Error Response Format
```python
interface ErrorResponse {
    error: {
        message: string,
        type: string,
        code: string
    }
}
```

## Token Management

### Token Counting
```python
# Response usage info
interface Usage {
    prompt_tokens: int,
    completion_tokens: int,
    total_tokens: int
}

# Approximate token calculation
def count_tokens(text: str) -> int:
    # Implementation depends on chosen method
    pass
```

## Cost Calculation
```python
# Model costs (per 1K tokens)
MODEL_COSTS = {
    "gpt-3.5-turbo": {
        "input": 0.0015,
        "output": 0.002
    },
    "gpt-4": {
        "input": 0.03,
        "output": 0.06
    }
}
