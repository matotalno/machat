# Modern AI Chat Aplikacija

## 🎯 Glavni Ciljevi
1. Sačuvati postojeću chat funkcionalnost ✅
2. Dodati UI elemente (sidebar, settings, sesije) ⏳
3. Organizovati API postavke u Settings ⏳
4. Implementirati napredne funkcije ⏳

## 📊 Status Implementacije

### 1. Postojeća Funkcionalnost ✅
- [x] Chat prozor sa porukama
- [x] OpenAI API integracija
- [x] Streaming odgovora
- [x] Osnovno čuvanje sesija

### 2. Struktura i Dopune ⏳

#### 2.1 Sidebar (TODO)
- [ ] Dimenzije: 240-300px širina
- [ ] Elementi:
  - [ ] Logo (50-60px visina)
  - [ ] New Chat dugme
  - [ ] Lista sesija + search
  - [ ] Settings dugme
  - [ ] Clear/Logout opcija
- [ ] Responsive: <800px = ikonice

#### 2.2 Chat Prozor (U RAZVOJU)
- [x] Scroll area za poruke
- [x] Message bubbles (osnovni)
- [ ] Header (48-50px):
  - [ ] Naziv sesije
  - [ ] Export/Search/Pin
- [ ] Markdown/Code podrška
- [ ] Akcione ikonice

#### 2.3 Input Bar (PLANIRANJE)
- [x] Osnovni TextEdit
- [ ] Multiline (do 5 redova)
- [ ] Attachments
- [ ] Voice input
- [ ] Emoji podrška

#### 2.4 Settings Dialog (TODO)
- [ ] API Settings:
  - [ ] API Key (masked)
  - [ ] Model selection
  - [ ] Temperature/tokens
- [ ] UI Settings:
  - [ ] Dark/Light tema
  - [ ] Font veličina
- [ ] Advanced:
  - [ ] System prompts
  - [ ] Token usage
  - [ ] Batch processing

## 📁 Potrebne Komponente

### QML Fajlovi
1. ChatView.qml (postojeći) ✅
   - Glavna chat komponenta
   - Prikaz poruka
   
2. MessageDelegate.qml (postojeći) ✅
   - Renderiše pojedinačne poruke
   - Avatar i timestamp

3. SidebarView.qml (TODO)
   - Layout: ColumnLayout
   - Session lista
   - Search funkcionalnost

4. InputBar.qml (TODO)
   - Multiline input
   - Akciona dugmad
   - Event handling

5. SettingsDialog.qml (TODO)
   - Modal dijalog
   - Tabbed interfejs
   - Form kontrole

### Python Backend
1. openai_client.py (proširiti)
   - [ ] Model management
   - [ ] Token counting
   - [ ] Batch processing

2. chat_bridge.py (proširiti)
   - [ ] Settings handler
   - [ ] Export/Import
   - [ ] Session search

## 🗓️ Plan Implementacije

### Faza 1: Core UI
1. Kreirati SidebarView.qml
2. Izdvojiti InputBar.qml
3. Implementirati SettingsDialog.qml

### Faza 2: Funkcionalnosti
1. Session Management
   - Pin/Rename/Delete
   - Search/Filter
   - Export/Import

2. Settings & Config
   - API podešavanja
   - UI tema
   - Token counting

### Faza 3: Polish
1. Markdown/Code podrška
2. Responzivan dizajn
3. Error handling
4. Performanse optimizacije

## 🎨 UI Specifikacije

### Dimenzije
- Window: 800x600px min
- Sidebar: 240-300px
- Header: 48-50px
- Input: 48-60px
- Avatari: 30x30px

### Boje
- Dark mode:
  - Sidebar: #2f2f2f
  - Background: #1f1f1f
- Light mode:
  - Background: #ffffff
- Akcenti:
  - User: #007AFF
  - AI: #19c37d

## 💾 Storage Format
