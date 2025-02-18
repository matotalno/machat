# Modern AI Chat - State Management

## Data Flow

### 1. Session State
```typescript
interface SessionState {
    currentSessionId: string;
    sessions: {
        id: string;
        title: string;
        isPinned: boolean;
        messages: Message[];
        lastUpdated: number;
        tokenCount: number;
    }[];
}
```

### 2. Settings State
```typescript
interface SettingsState {
    api: {
        key: string;
        model: string;
        temperature: number;
        maxTokens: number;
        topP: number;
        frequencyPenalty: number;
        presencePenalty: number;
    };
    ui: {
        theme: 'light' | 'dark';
        language: string;
        fontSize: number;
    };
    advanced: {
        systemPrompt: string;
        showTokenCount: boolean;
        timeout: number;
        enableBatch: boolean;
        enableTools: boolean;
    };
}
```

## Komponente i Komunikacija

### 1. MainWindow ↔ Components
- Upravlja glavnim stanjem
- Prosleđuje callbacks
- Koordinira updates

### 2. SidebarView ← → SessionManager
- Lista sesija
- Search/Filter
- Pin/Rename/Delete

### 3. ChatView ← → OpenAIClient
- Message sending
- Streaming
- Error handling

### 4. SettingsDialog ← → Settings Handler
- Load/Save settings
- Validate input
- Apply changes

## Event System
1. Session Events:
   - sessionCreated
   - sessionUpdated
   - sessionDeleted
   - sessionPinned

2. Message Events:
   - messageSending
   - messageReceived
   - messageError

3. Settings Events:
   - settingsChanged
   - themeChanged
   - apiKeyUpdated
