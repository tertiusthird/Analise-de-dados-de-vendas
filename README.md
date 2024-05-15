# Exploração de dados de vendas.

## Introdução
Análise de vendas em um banco de dados usando SQL, com o objetivo de descobrir insights diversos. Identificar os produtos mais vendidos, os maiores clientes e a taxa de crescimento das vendas.

Neste banco de dados, temos registros de pedidos de diferentes tipos de papel feitos por empresas como Walmart, Microsoft, entre outras. Podemos ver quanto de cada tipo de papel foi encomendado, quanto foi gasto, quem foi responsável pelo pedido, em qual região a empresa está localizada e as datas dos diferentes eventos da web realizados por cada empresa.

Uma análise SQL das vendas em diferentes tipos de papel.
* [Sales Analysis](https://github.com/tertiusthird/Analise-de-dados-de-vendas/blob/main/Analise%20de%20vendas.md)

## Datasets usados
- <strong>accounts</strong>:  Esta tabela contém todas as diferentes empresas, seus IDs (account_id), site, ponto de contato e o ID do representante de vendas.
- <strong>orders</strong>: Timestamp de cada pedido, a quantidade encomendada de cada tipo de papel (standard_qty, gloss_qty, poster_qty), o total, quanto dinheiro foi gasto em cada tipo de papel (standard_amt_usd, gloss_amt_usd, poster_amt_usd) e o total em dólares.
- <strong>region</strong>:  Quatro regiões: Nordeste, Centro-Oeste, Sudeste, Oeste
- <strong>sales_reps</strong>:  Esta tabela mostra todos os nomes dos representantes de vendas com seus respectivos IDs e IDs de região.
- <strong>web_events</strong>: Todos os eventos da web realizados por cada empresa, o ID da conta, a data em que cada evento da web foi realizado e o canal (Facebook, Twitter, etc).

## Diagrama do relacionamento das tabelas
![alt text](https://github.com/tertiusthird/Analise-de-dados-de-vendas/blob/main/ERD.png)

