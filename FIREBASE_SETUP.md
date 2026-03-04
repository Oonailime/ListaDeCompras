# Firebase Configuration Setup

## Erro: "Auth error (configuration-not-found)"

Este erro ocorre porque falta o arquivo de configuração do Firebase no projeto Android.

## Solução

### 1. Baixar `google-services.json` do Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto **ibuy-bym**
3. Clique no ícone de engrenagem ⚙️ no canto superior esquerdo → **Configurações do Projeto**
4. Abra a aba **Apps** 
5. Procure pelo app Android (deve ter um ícone de Android) - se não existir, adicione um
6. Clique em **google-services.json** para fazer download
7. Coloque o arquivo em: `android/app/google-services.json`

### 2. Verificar Configuração do Android

Já foi feita a configuração do `android/build.gradle` e `android/app/build.gradle`:
- ✅ Adicionado `classpath 'com.google.gms:google-services:4.3.15'` em `android/build.gradle`
- ✅ Adicionado `apply plugin: 'com.google.gms.google-services'` em `android/app/build.gradle`

### 3. Rebuildar o Projeto

Após colocar o `google-services.json` em `android/app/`:

```bash
flutter clean
flutter pub get
flutter run
```

## Se Ainda Tiver Problemas

### Verificar se Email/Password está habilitado no Firebase

1. Vá para Firebase Console
2. Selecione o projeto **ibuy-bym**
3. Vá para **Authentication** (no menu lateral esquerdo)
4. Abra a aba **Sign-in method**
5. Procure por **Email/Password** e clique em ativar (habilitar)
6. Salve as mudanças

## Arquivos de Configuração Esperados

- `android/app/google-services.json` ← **NECESSÁRIO fazer download do Firebase Console**
- `lib/firebase_options.dart` ✅ (já gerado e configurado)
- `android/build.gradle` ✅ (já atualizado)
- `android/app/build.gradle` ✅ (já atualizado)
