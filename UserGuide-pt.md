## Aplicativo de Meditação Garmin

### Recursos

- Capacidade de salvar a sessão de meditação como atividade do Garmin Connect
  - Tipo de atividade: **Meditação** ou **Yoga**
- Capacidade de configurar sessões de meditação/yoga múltiplas
  - Exemplo: uma sessão de 20 minutos com alertas recorrentes de 1 minuto, que acionam um alerta diferente a cada 10 minutos
  - Cada sessão suporta alertas por intervalo vibratório
  - Alertas de intervalo podem acionar de poucos segundos até poucas horas
- Sessões com duração padrão predefinida de 5/10/15/20/25/30min com intervalo curto de vibração a cada 5min
- Também sessões de meditação padrão avançadas de 45min e 1h com intervalo curto de vibração a cada 15 min 
- [HRV](https://en.wikipedia.org/wiki/Heart_rate_variability) (Variabilidade da Frequência Cardíaca)
  - RMSSD - Média Quadrática das Diferenças Sucessivas (intervalos batida-para-batida)
  - pNN20 - % de intervalos batida-para-batida que diferem mais de 20 ms
  - pNN50 - % de intervalos batida-para-batida que diferem mais de 50 ms
  - leitura direta do intervalo batida-para-batida do sensor de frequência cardíaca
  - HRV Sucessivas Diferenças - diferença entre o intervalo atual e os batimentos intervalos batida-para-batida anteriores
  - SDRR - [Desvio Padrão](https://en.wikipedia.org/wiki/Standard_deviation) dos intervalos batida-para-batida
    - calculado dos primeiros e últimos 5 minutos da sessão
  - HRV RMSSD Janela de 30 Seg - RMSSD calculado para intervalos consecutivos de 30 segundos
  - HR de batimento cardíaco - intervalo batida-para-batida convertido para BPM
- Rastreamento de estresse
  - Stress - resumo do estresse médio durante a sessão 
  - Média de estresse para o início e fim da sessão (calculado automaticamente pelo relógio para sessão de 5min ou mais)
  - Picos de HR Janela de 10 Segundos
    - medir internamente para calcular estresse
    - rastreia sobrepondo 10 Segundos na janela Máximo HR para cada janela
    - HR calculado de intervalo batida-para-batida
- Taxa de Respiração
  - Respirações por minuto em tempo real em relógios que oferecem suporte (funciona somente para atividade de Yoga devido a bug na API Connect IQ para atividade de Respiração)
- capacidade de configurar tempo de preparação antes da sessão de meditação
- estatísticas resumidas no final da sessão
  - gráfico de taxa de coração incluindo mín, média e máx HR
  - gráficos de taxa de respiração incluindo mín, média e máx taxa estimada de respiração
  - Estresse
  - HRV 
- pausar/retomar sessão atual usando o botão voltar
- capacidade de configurar nome de atividade personalizado padrão no Garmin Connect usando a ferramenta Garmin Express em um PC conectado ao relógio via cabo USB

### Como Usar

1. **Iniciando uma Sessão**

   1.1. Na tela "session picker", pressione o botão "start" ou toque a tela (somente para dispositivos touchscreen).

   1.2. A tela de sessão em andamento contém os seguintes elementos:
   - cronômetro inverso
     - mostra a porcentagem do tempo restante da sessão decorrido
     - o círculo completo significa que o tempo da sessão já terminou
   - alarmes intervalados
     - o pequeno marcador colorido representa o tempo de acionamento de intervalo de alarme
     - cada posição marcada corresponde a um tempo de intervalo de alarme acionado
     - você pode ocultá-los por alarme selecionando "cor transparente" no menu de configurações de Intervalos de Alerta (#2-configurando-uma-sessão)
   - Tempo transcorreu
   - HR atual
   - HRV atual Sucessiva Diferença
   - diferença entre intervalos de batimento-batida anteriores e atuais medidos em milissegundos
   - mostra apenas quando o rastreamento HRV está ativado
   - **para obter boas leituras de HRV, você precisa minimizar o movimento do pulso**
   - taxa de respiração atual estimada pelo relógio
     - **para obter boas leituras de respiração, você precisa minimizar o movimento do pulso**

A sessão de meditação termina quando você pressiona o botão "start/stop". Você pode pausar/retomar a sessão usando o botão voltar. Habilitar/desabilitar luz de tela durante a sessão usando o botão de luz ou tocando a tela (somente dispositivos touchscreen).

1.3. Uma vez que você para a sessão, você pode optar por salvá-la.

1.3.1. Você pode configurar para salvar automaticamente ou descartar automaticamente a sessão através das [Configurações Globais](#4-global-settings) -> [Confirmação de Salvar](#42-confirme-salvar)

1.4. Se você estiver no modo de sessão única (padrão), no final você vê a Tela de Resumo (para o modo Multi-Sessão, veja a próxima seção *1.5*). Deslize para cima/baixo (somente dispositivos touchscreen) ou pressione botões para cima/baixo na tela de resumo para ver as estatísticas de HR, Stress e HRV. Volte desta visão para sair do aplicativo.

1.5. Se você estiver no modo Multi-Sessão (determinado pelas [Configurações Globais](#4-global-settings) -> [Multi-Sessão](#43-multi-session)), você pode voltar à tela "session picker". De lá, você pode iniciar outra sessão. Uma vez que você termina sua sessão, você pode voltar da tela "session picker" para entrar na vista Resumo de Sessões.

1.6. Da vista Resumo de Sessões, você pode abrir a sessão individual ou sair do aplicativo. Descer mostra estatísticas de resumo de HR, Taxa de Respiração, Stress e HRV. Se você voltar da vista Resumo de Sessões, você pode continuar fazendo mais sessões.

### 2. Configurando uma Sessão

2.1. Na tela "session picker", mantenha o botão "menu" pressionado (meio à esquerda) até ver o "Menu de Configurações da Sessão".

- para dispositivos com tela sensível ao toque suportados, também é possível tocar e segurar na tela

2.2. Em Adicionar/Editar, você pode configurar:
- Tempo - duração total da sessão em HH:MM
- Cor - a cor da sessão usada nos controles gráficos; selecione usando a opção de comportamento ao subir/descer no relógio (Vivoactive 3/4/Venu - deslize para cima/baixo)
- Padrão de Vibração - padrões mais curtos ou mais longos, variando de pulsação única a contínua
- Alertas Intervalados - capacidade de configurar alertas intermitentes múltiplios
  - uma vez que você está em um alerta intervalado específico, vê no menu o título do ID de Alerta (e.g. Alerta 1) relativo ao intervalo atual de alarme
  - Tempo 
    - selecione alarme individual ou repetitivo
    - alarmes repetitivos permitem durações mais curtas que um minuto
    - apenas um único alarme será executado a qualquer dado momento
    - prioridade de alarmes com o mesmo tempo
    - 1. alerta de sessão final
    - 2. último alarme único
    - 3. último alarme repetitivo
  - Cor - a cor do alerta intervalado atual usado nos controles gráficos. Selecione cores diferentes para cada alerta para diferenciá-los durante a meditação. Selecione "cor transparente" se não quiser visualizar marcas para o alerta durante a meditação
  - Padrão de Vibração/Som - padrões mais curtos ou mais longos, variando de pulsação única a contínua ou som
- Tipo de Atividade - capacidade de salvar a sessão como **Meditação** ou **Yoga**. Você pode configurar tipo de atividade padrão para novas sessões nas Configurações Globais (veja seção 4)

2.3 Excluir - deleta uma sessão após pedir confirmação

2.4 Configurações Globais - [veja seção 4](#4-global-settings)

### 3. Escolhendo uma Sessão

Na tela "session picker", pressione botões para cima/baixo (para dispositivos de toque deslize para cima/baixo). Nesta tela você pode ver as configurações aplicáveis para a sessão selecionada
- tipo de atividade - no título
  - Meditação
- tempo - duração total da sessão
- padrão de vibração
- alertas intervalados - o gráfico no meio da tela representa o tempo de alerta relativo comparado ao tempo total de sessão
- Indicador HRV
  - ![Off](userGuideScreenshots/hrvIndicatorOff.png) Desligado - indica que o rastreamento de estresse e HRV estão desativados
  - ![Esperar HRV](userGuideScreenshots/hrvIndicatorWaitingHrv.png) Esperando HRV 
    - o sensor de hardware não detecta HRV
    - você pode iniciar a sessão mas os dados HRV estarão em falta, recomenda-se ficar quieto até que HRV esteja pronto
  - ![HRV Pronto](userGuideScreenshots/hrvIndicatorReady.png) HRV Pronto
    - o sensor de hardware detecta HRV
    - a sessão rastreia padrão de HRV e métricas de Estresse
    - **a sessão pode ser registrada com dados confiáveis de HRV provendo que você minimize movimentos de punho**

### 4. Configurações Globais

Na tela "session picker", mantenha o botão "menu" pressionado (ou toque e segure a tela) até ver o Menu de Configurações da Sessão. Selecione o Menu Configurações Globais. Você verá uma visão com o estado das configurações globais. Mantenha o botão "menu" pressionado novamente (ou toque e segure a tela) para editar configurações globais.

#### 4.1 Rastreamento de HRV

Esta configuração fornece a *Rastreamento de HRV* padrão para novas sessões.
- **Ligado** - rastreia métricas HRV e Estresse padrão
  - RMSSD
  - Diferenças Sucessivas
  - Estresse
- **Desligado** (Padrão) - rastreia extra métricas HRV além da opção **Ligado**
  - RMSSD
  - Diferenças Sucessivas
  - Estresse
  - intervalo batida-para-batida
  - pNN50
  - pNN20
  - HR de batimento cardíaco
  - RMSSD 30 Seg Janela
  - HR Picos 10 Seg Janela
  - SDRR Primeiro 5min da sessão
  - SDRR Último 5min da sessão
- **Desligado** - *HRV e Estresse* rastreamento desativado

#### 4.2 Confirmação de Salvar

- Pergunta - ao finalizar uma atividade pergunta para confirmar se deseja salvar a atividade
- Automático Sim - ao finalizar uma atividade salva automaticamente
- Automático Não - ao finalizar uma atividade descarta automaticamente

#### 4.3 Multi-Sessão

- Sim 
  - o aplicativo continua a rodar após finalizar sessão
   - isso permite que você registre várias sessões
- Não 
  - o aplicativo sai após finalizar sessão

#### 4.4 Tempo de Preparação

- 0 seg - Sem tempo de preparação
- 15 seg (Padrão) - 15s para preparação antes de iniciar a sessão de meditação
- 30 seg - 30s para preparação antes de iniciar a sessão de meditação
- 60 seg - 1min para preparação antes de iniciar a sessão de meditação

#### 4.5 Taxa de Respiração (nota: alguns dispositivos não suportam este recurso)

- Ligada (Padrão) - Taxa de respiração habilitada durante sessões
- Desligada - Taxa de respiração desabilitada durante sessões

#### 4.6 Novo Tipo de Atividade

Você pode definir o tipo de atividade padrão para novas sessões.

- Yoga
- Meditação
