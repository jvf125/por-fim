#!/bin/bash

# 🚀 SCRIPT DE DEPLOY - LIMPEZA PRO
# Executa todos os 5 passos automaticamente

set -e

echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                            ║"
echo "║            🚀 INICIANDO DEPLOY - LIMPEZA PRO (COMPLETO)                    ║"
echo "║                                                                            ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""

# CORES
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# PASSO 1: VALIDAR BACKEND
echo -e "${YELLOW}[1/5]${NC} Validando backend..."
cd backend

if [ ! -d "node_modules" ]; then
  echo "   📦 Instalando dependências..."
  npm install --quiet
else
  echo "   ✅ Dependências já instaladas"
fi

echo "   💾 Rodando migrations..."
npm run migrate > /dev/null 2>&1

echo "   🧪 Executando testes (test:ci)..."
if npm run test:ci > /dev/null 2>&1; then
  echo -e "   ${GREEN}✅ Todos os testes passaram!${NC}"
else
  echo -e "   ${RED}❌ Testes falharam! Revise os erros acima.${NC}"
  cd ..
  exit 1
fi

cd ..
echo ""

# PASSO 2: VALIDAR VARIÁVEIS DE AMBIENTE
echo -e "${YELLOW}[2/5]${NC} Validando configuração..."
if [ ! -f "backend/.env" ]; then
  echo -e "   ${RED}❌ Arquivo backend/.env não encontrado!${NC}"
  echo "   💡 Copie backend/.env.example para backend/.env e preencha as credenciais"
  echo "   Credenciais necessárias:"
  echo "      • STRIPE_SECRET_KEY (Stripe)"
  echo "      • PIX_BANK_API_URL (Conexão com banco)"
  echo "      • TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN (SMS/WhatsApp)"
else
  echo "   ✅ Arquivo .env configurado"
  
  # Validar que não está vazio
  if grep -q "STRIPE_SECRET_KEY=" backend/.env && [ -z "$(grep '^STRIPE_SECRET_KEY=' backend/.env | cut -d= -f2)" ]; then
    echo -e "   ${YELLOW}⚠️  STRIPE_SECRET_KEY está vazio (importante para produção)${NC}"
  fi
fi

echo ""

# PASSO 3: BUILD BACKEND
echo -e "${YELLOW}[3/5]${NC} Backend pronto para produção..."
cd backend
echo "   ✅ Backend testado e validado (npm start para iniciar)"
cd ..
echo ""

# PASSO 4: BUILD FRONTEND
echo -e "${YELLOW}[4/5]${NC} Compilando frontend (Next.js)..."
cd frontend

if [ ! -d "node_modules" ]; then
  echo "   📦 Instalando dependências..."
  npm install --quiet
else
  echo "   ✅ Dependências já instaladas"
fi

echo "   🔨 Building Next.js..."
if npm run build > /dev/null 2>&1; then
  echo -e "   ${GREEN}✅ Frontend compilado com sucesso!${NC}"
else
  echo -e "   ${RED}❌ Erro ao compilar frontend!${NC}"
  echo "   💡 Execute: npm run build (com outputs) para ver o erro"
  cd ..
  exit 1
fi

cd ..
echo ""

# PASSO 5: INSTRUÇÕES FINAIS
echo -e "${YELLOW}[5/5]${NC} Instruções de initialização..."
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}                ✅ TUDO PRONTO PARA DEPLOY!${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "📱 Para iniciar localmente (em 2 terminais):"
echo ""
echo "   Terminal 1 (Backend):"
echo "   $ cd backend && npm start"
echo ""
echo "   Terminal 2 (Frontend):"
echo "   $ cd frontend && npm start"
echo ""
echo "   Então abra: http://localhost:3001"
echo ""
echo "🌍 Para deploy em produção:"
echo "   $ npm run deploy:production"
echo "   (ou use seu provedor: Vercel, Netlify, AWS, Heroku, etc)"
echo ""
echo "📚 Mais informações:"
echo "   • DEPLOYMENT_READY.md - Guia completo"
echo "   • backend/TESTING_STRATEGY.md - Estratégia de testes"
echo "   • TODO_ITEMS.md - Checklist"
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
