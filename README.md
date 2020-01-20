## Dependências

Este projeto foi totalmente desenvolvido usando a linguagem R na versão 3.6.0, parte em sistemas Windows e parte em sistemas Linux.

O controle de versões dos pacotes utilizados foi feito com ajuda do pacote [checkpoint](https://github.com/RevolutionAnalytics/checkpoint). Para instalar todas as dependências, basta instalar o pacote executando

```r
install.packages('checkpoint')
```

E executar o script `setup_environment.R`.

## Destaques

Este projeto foi desenvolvido em 3 etapas:

1. [Análise exploratória](exploratory_analysis/exploratory_analysis.md)
2. [Modelagem](modelling/train_xgb.R)
3. [Deploy do modelo como uma aplicação web](https://guilhermejordan.shinyapps.io/predict_rain_australia/)


- Foi treinado um modelo com ROC AUC de 0.98 na base de teste.
- O modelo foi disponibilizado como uma aplicação web, facilitando sua aplicação e utilização.


### Estrutura do projeto

- `exploratory_analysis`: arquivos relacionados à análise exploratória
- `modelling`: arquivos relacionados à modelagem
- `app`: arquivos relacionados à aplicação web
- `r_functions`: funções auxiliares

### Análise exploratória

- Detectamos problemas como outliers e valores missings
- Identificamos que a variável `modelo_vigente` corresponde ao modelo usado atualmente
- Identificamos que a variável `amountOfRain` não deve ser usada como preditora
- Mais detalhes podem ser lidos [aqui](exploratory_analysis/exploratory_analysis.md)

### Modelagem

- Treinamos um modelo `xgboost` utilizando o framework de machine learning `caret`
- Escolhemos esse modelo pois assim não precisamos nos preocupar muito com o preprocessamento (escalar, centralizar, tratar outliers, tratar valores missing) pois este modelo não depende dessas etapas
- Construímos diversas features incorporando conhecimento do contexto:

```r 
tempamplitude = maxtemp - mintemp,
tempchange = temp3pm - temp9am,
humiditychange = humidity3pm - humidity9am,
pressurechange = pressure3pm - pressure9am,
precipitationchange = precipitation3pm - precipitation9am,
cloudchange = cloud3pm - cloud9am,
month = lubridate::month(date)
```
    
- Obtivemos um score ROC AUC de 0.98 na base de teste

### Deploy na web

- Criamos uma aplicação web para facilitar a aplicação do modelo. Ela pode ser acessada em https://guilhermejordan.shinyapps.io/predict_rain_australia/
- Permitimos que o modelo possa ser usado por qualquer um, em qualquer lugar


