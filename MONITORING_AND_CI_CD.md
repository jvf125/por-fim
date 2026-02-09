# 🚀 Monitoring, Testing & CI/CD Setup

## Overview

Este documento descreve a configuração de **monitoring**, **testes E2E** e **CI/CD** implementados para o Leidy Cleaner.

---

## 📊 Sentry - Error Tracking & Performance Monitoring

### Configuração

Sentry está integrado no backend para capturar erros, exceções e rastrear performance em tempo real.

**Variáveis de Ambiente:**
```bash
SENTRY_DSN=https://xxxxxxx@sentry.io/xxxxx
NODE_ENV=production
APP_VERSION=1.0.0
```

### Features

✅ **Error Tracking**
- Captura automática de exceptions não tratadas
- Rastreamento de erros HTTP 5xx
- Stack traces com contexto de aplicação

✅ **Performance Monitoring**
- Tracing de requisições (P50, P95, P99)
- Detecção de gargalos
- Profiling de CPU (10% das requisições em prod)

✅ **Release Tracking**
- Vinculação de erros a releases específicas
- Changelog automático
- Source maps para stack traces legíveis

✅ **Custom Context**
- User ID e role na sessão
- IDs de booking/pagamento envolvidos
- Headers e parâmetros (sensíveis removidos)

### Como Usar

```javascript
// Importar
const { captureException, captureMessage, startTransaction } = require('./config/sentry');

// Capturar exceção
try {
  // código
} catch (error) {
  captureException(error, { bookingId, userId });
}

// Capturar mensagem
captureMessage('PIX webhook recebido', 'info', { transactionId });

// Rastrear operação longa
const txn = startTransaction('reconcile_payments', 'db');
// ... operação ...
txn.finish();
```

### Dashboard Sentry

Acesse: https://sentry.io → Selecione projeto "leidy-cleaner" → Veja issues, performance, releases em tempo real.

---

## 🧪 Testes E2E - Playwright

### Arquivos de Teste

📁 `backend/e2e/pix-payment.spec.ts` — Testes completos do fluxo PIX

### Casos de Teste Cobertos

| # | Caso | Status |
|---|------|--------|
| 1 | Registro e login de usuário | ✅ |
| 2 | Criar agendamento | ✅ |
| 3 | Gerar QR Code PIX | ✅ |
| 4 | Criar pagamento PIX | ✅ |
| 5 | Verificar status (pendente) | ✅ |
| 6 | Simular webhook confirmado | ✅ |
| 7 | Verificar status (confirmado) | ✅ |
| 8 | Validar atualização de booking | ✅ |
| 9 | Verificar histórico de pagamentos | ✅ |
| 10 | Testar idempotência de webhook | ✅ |
| 11 | Rejeitar assinatura inválida | ✅ |
| 12 | Rejeitar timestamp expirado | ✅ |

### Executar Localmente

```bash
# Instalar Playwright
npx playwright install --with-deps

# Iniciar backend em uma aba
npm start

# Em outra aba, rodar testes
npm run test:e2e

# Modo debug
npx playwright test --debug

# Interface web
npx playwright test --ui
```

### Configuração

```javascript
// playwright.config.ts
const config = {
  testDir: './backend/e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  use: {
    baseURL: process.env.E2E_BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
};
```

---

## 🔄 CI/CD Pipeline - GitHub Actions

### Workflow Stages

Arquivo: `.github/workflows/ci-cd.yml`

#### 1️⃣ **Test** (Paralelo: backend + frontend)
- ESLint, Prettier, testes unitários
- Coverage > 70% (recomendado)
- Artifacts: coverage reports

#### 2️⃣ **Lint**
- ESLint em backend e frontend
- Security audit (npm audit)

#### 3️⃣ **E2E** (PR only)
- Playwright tests (PIX payment flow)
- Screenshots/videos on failure
- Artifacts: playwright-report

#### 4️⃣ **Security**
- npm audit para vulnerabilidades
- TruffleHog para secrets detection
- Semgrep for SAST

#### 5️⃣ **Build**
- Backend build (production mode)
- Frontend build (Next.js)
- Artifacts: dist, build, .next

#### 6️⃣ **Deploy Staging** (develop branch)
- Frontend → Vercel
- Backend → Railway
- Slack notification

#### 7️⃣ **Deploy Production** (main branch)
- Frontend → Vercel
- Backend → Railway
- Create GitHub Release
- Slack notification

### Triggers

```yaml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
```

### Environment Variables Necessários

```bash
# Vercel (Frontend)
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID

# Railway (Backend)
RAILWAY_TOKEN
RAILWAY_PROJECT_ID

# Slack
SLACK_WEBHOOK

# Codecov
CODECOV_TOKEN (auto)
```

### Status Badge

Adicione ao `README.md`:
```markdown
[![CI/CD](https://github.com/jvf125/por-fim/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/jvf125/por-fim/actions/workflows/ci-cd.yml)
```

---

## 📈 Métricas & Observabilidade

### Sentry Metrics

- **Error Rate**: Erros por minuto
- **User Sessions**: Usuários ativos
- **Performance**: P50/P95/P99 de latência
- **Release Health**: Crash rate por release

### CI/CD Metrics

- **Test Coverage**: % de cobertura (target: >70%)
- **Build Time**: Duration do build
- **Deploy Success Rate**: % de deploys bem-sucedidos
- **Pipeline Duration**: Total de tempo

### Custom Dashboards

Crie em Sentry:
1. Dashboard → New Dashboard
2. Add Widget → Add Release Health
3. Add Widget → Add Performance Distribution
4. Save e compartilhe com time

---

## 🔐 Security Checklist

### Antes de Deploy

- [ ] npm audit sem vulnerabilidades críticas
- [ ] Secrets escaneados (TruffleHog)
- [ ] SAST scan (Semgrep) passou
- [ ] E2E tests passaram
- [ ] Coverage > 70%
- [ ] Code review aprovada

### Principais Vulnerabilidades Monitoradas

- SQL Injection (OWASP A1)
- XSS (OWASP A3)
- CSRF (OWASP A2)
- Authentication bypass (OWASP A7)
- Insecure dependencies

---

## 🚨 Alertas & Notifications

### Slack Notifications

O pipeline dispara notificação ao:
- ❌ Testes falharem
- ❌ Build falhar
- ✅ Deploy bem-sucedido
- ⚠️ Security issues encontradas

**Canal**: Configure em `.github/workflows/ci-cd.yml`

### Sentry Alerts

1. Acesse Sentry → Project → Alerts
2. Crie alert para:
   - `error.level:error` → Slack channel
   - `event.transaction:api.pix.webhooks AND event.level:error`
   - Spike detection em error rate

### Health Checks

```bash
# Backend health
curl http://localhost:3000/api/health

# Sentry status
curl https://sentry.io/api/0/organizations/seu-org/
```

---

## 📋 Troubleshooting

### E2E Tests Falhando

```bash
# Modo debug com UI
npx playwright test --ui

# Ver logs
npx playwright test --reporter=list

# Reexecutar com video
PWDEBUG=1 npm run test:e2e
```

### Sentry DSN Inválido

```bash
# Verificar
echo $SENTRY_DSN

# Testar
curl -X POST https://seu-sentry-dsn@sentry.io/xxxxx \
  -H "Content-Type: application/json" \
  -d '{"message":"Test"}'
```

### CI/CD Timeout

- Aumentar timeout em `playwright.config.ts`
- Reduzir workers em CI
- Cachear dependências com `@actions/setup-node`

---

## 📚 Referências

- [Sentry Docs](https://docs.sentry.io/)
- [Playwright Docs](https://playwright.dev/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

---

**Status**: ✅ Implementado e testado

**Último update**: 2026-02-09

**Maintainer**: @jvf125
