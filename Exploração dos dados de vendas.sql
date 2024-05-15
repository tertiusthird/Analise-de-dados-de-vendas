/*1. Forneça uma tabela que apresente a região para cada representante de vendas, juntamente com suas contas associadas.
Desta vez, apenas para a região Centro-Oeste. Ordene as contas em ordem alfabética (A-Z) de acordo com o nome da conta.*/

-- Como queremos o nome da região, o nome do representante de vendas e o nome da conta, precisamos trabalhar com 3 tabelas: regiões, representantes de vendas e contas
-- Selecionamos a coluna "name" da tabela de regiões, a coluna "name" da tabela de representantes de vendas e a coluna "name" da tabela de contas
-- Em seguida, fazemos um join entre a tabela de regiões e a tabela de representantes de vendas, e depois entre essa junção e a tabela de contas
-- Como queremos apenas a região Centro-Oeste, filtramos com uma cláusula "where"
-- E, por fim, ordenamos pelo nome da conta


SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest'
ORDER BY ac.name ASC




/*2. Forneça uma tabela que apresente a região para cada representante de vendas, juntamente com suas contas associadas.
Desta vez, apenas para contas em que o nome do representante de vendas começa com S e na região Centro-Oeste.
Ordene as contas em ordem alfabética (A-Z) de acordo com o nome da conta.*/

-- Aqui adicionamos outra condição: o primeiro nome do representante de vendas deve começar com S.
-- Portanto, na cláusula "where", adicionamos mais uma condição.


SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest' AND sr.name LIKE 'S%'
ORDER BY ac.name ASC




/*3. Forneça uma tabela que apresente a região para cada representante de vendas, juntamente com suas contas associadas.
Desta vez, apenas para contas em que o sobrenome do representante de vendas começa com K e na região Centro-Oeste.
Ordene as contas em ordem alfabética (A-Z) de acordo com o nome da conta.*/

-- Nesta consulta, o sobrenome do representante de vendas deve começar com K
-- Portanto, substituímos a segunda condição que tínhamos por outra que extrai os registros que atendem a essa condição acima


SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest' AND sr.name LIKE '% K%'
ORDER BY ac.name ASC




/*4. Forneça o nome de cada região para cada pedido, bem como o nome da conta e o preço unitário que pagaram
(total_amt_usd/total) pelo pedido. No entanto, você deve fornecer os resultados apenas se a quantidade padrão do pedido for superior a 100.
Para evitar um erro de divisão por zero, adicionar 0,01 ao denominador aqui é útil total_amt_usd/(total+0,01).*/

-- Queremos a região, o nome da conta e o preço unitário; portanto, vamos trabalhar com as tabelas de região, contas e pedidos
-- Também precisaremos da tabela de representantes de vendas para fazer o join entre as tabelas mencionadas acima
-- E, em seguida, adicionamos uma condição: queremos apenas os pedidos com mais de 100 unidades de papel padrão

SELECT r.name AS region, ac.name AS account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100



/*5. Forneça o nome de cada região para cada pedido, bem como o nome da conta e o preço unitário que pagaram (total_amt_usd/total)
pelo pedido. No entanto, você deve fornecer os resultados apenas se a quantidade padrão do pedido for superior a 100 e a quantidade de pôsteres
for superior a 50. Ordene pelo menor preço unitário primeiro.*/

-- Para a consulta acima, adicionamos uma nova condição: queremos apenas os pedidos com mais de 100 unidades de papel padrão e mais de 50 unidades de papel de pôster
-- E, em seguida, ordenamos a tabela para visualizar o nome da conta com o menor preço unitário

SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price ASC



/*6. Forneça o nome de cada região para cada pedido, bem como o nome da conta e o preço unitário que pagaram (total_amt_usd/total)
pelo pedido. No entanto, você deve fornecer os resultados apenas se a quantidade padrão do pedido for superior a 100 e a quantidade de pôsteres
for superior a 50. Ordene pelo maior preço unitário primeiro.*/

-- Aqui ordenamos a tabela para visualizar o nome da conta com o maior preço unitário

SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC



/*7. Para cada conta, determine a quantidade média de cada tipo de papel que eles compraram em seus pedidos.*/

-- Precisamos do nome da coluna da tabela de contas e da média de cada tipo de papel que cada uma das contas comprou
-- Assim, aplicamos a função de agregação avg() em cada tipo de papel
-- Como queremos o nome da conta e a média de cada tipo de papel que cada uma das contas comprou em seus pedidos
-- fazemos um join entre a tabela de contas e a tabela de pedidos
-- Por fim, agrupamos pelo nome da conta


SELECT ac.name AS account_name, AVG(o.standard_qty) AS average_standard_qty, AVG(o.gloss_qty) AS average_gloss_qty, 
AVG(o.poster_qty) AS average_poster_qty, AVG(total) as average_total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY average_standard_qty DESC




/*8. Para cada conta, determine o valor médio gasto por pedido em cada tipo de papel.*/

-- Aqui fazemos o mesmo, mas aplicamos a função avg() no valor gasto em cada tipo de papel

SELECT ac.name AS account_name, AVG(o.standard_amt_usd) AS avg_standard_amt_usd, AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd,
AVG(o.poster_amt_usd) AS avg_poster_amt_usd
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name

--Nesta query podemos visualizar qual account_name mais gastou
SELECT ac.name AS account_name, AVG(o.standard_amt_usd) AS avg_standard_amt_usd, AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd,
AVG(o.poster_amt_usd) AS avg_poster_amt_usd, AVG(o.standard_amt_usd)+AVG(o.gloss_amt_usd)+AVG(o.poster_amt_usd) as total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY total DESC



/*9. Determine o número de vezes que um canal específico foi usado na tabela web_events para cada representante de vendas.
Ordene sua tabela com o maior número de ocorrências primeiro.*/

-- Queremos o nome do representante de vendas, o canal e o número de ocorrências desses canais, portanto, trabalharemos com a tabela web_events, a tabela sales_reps
-- e indiretamente com a tabela accounts
-- Portanto, selecionamos a coluna name da tabela sales_reps, a coluna channel da tabela web_events e aplicamos a função count()
-- aos canais
-- Em seguida, como estamos trabalhando com as tabelas web_events e sales_reps, queremos uni-las. Mas a única maneira de fazer isso é através da
-- tabela accounts, então fazemos isso.
-- Agrupamos pelo nome do representante de vendas e pelo canal
-- E finalmente ordenamos pelo número de ocorrências
 

SELECT sr.name AS sales_rep_name, we.channel AS channel, count(channel) AS number_of_occurrences
FROM web_events we JOIN accounts ac ON we.account_id=ac.id JOIN sales_reps sr ON ac.sales_rep_id=sr.id
GROUP BY sr.name, we.channel
ORDER BY number_of_occurrences DESC




/*10. Quando olhamos para os totais anuais, podemos perceber que 2013 e 2017 têm totais muito menores do que todos os outros anos.
Se olharmos mais detalhadamente os dados mensais, veremos que para 2013 e 2017 há apenas um mês de vendas para cada um desses anos
(12 meses para 2013 e 1 mês para 2017). Portanto, nenhum deles está representado de forma equilibrada. As vendas têm aumentado ano após ano,
com 2016 sendo o ano de maiores vendas até o momento. Com base nessa tendência, podemos esperar que 2017 tenha as maiores vendas.*/

-- Aqui podemos ver os totais anuais
-- Extraímos o ano da coluna occurred_at da tabela orders e aplicamos a função sum() ao total_amt_usd também da tabela orders
-- Agrupamos por ano e, por fim, ordenamos pela coluna total_usd
-- Podemos ver que as vendas têm aumentado ano após ano


SELECT EXTRACT(YEAR FROM occurred_at) AS year,  SUM(total_amt_usd) AS total_usd
FROM orders
GROUP BY year
ORDER BY total_usd ASC



-- Neste, podemos ver o total por ano e mês
-- Como fizemos anteriormente, extraímos o ano da coluna occurred_at e também o mês.
-- Agrupamos por ano e mês
-- Podemos observar que para 2013 e 2017 há apenas um mês de vendas para cada um desses anos


SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month, SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at) = 2013 OR EXTRACT(YEAR FROM occurred_at)= 2017
GROUP BY year, month
ORDER BY year



-- Aqui também extraímos o dia
-- Pegamos os registros do ano de 2017
-- Podemos visualizar o total para cada dia do mês
-- Observamos que, para o ano de 2017, temos apenas o primeiro e o segundo dia de janeiro

SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at)=2017
GROUP BY year, month, day
ORDER BY total_usd ASC



-- Aqui comparamos o total em 1º de janeiro de 2017 com os outros anos
-- Adicionamos mais condições para que possamos visualizar o que mencionamos acima
-- Com base nessa tendência, podemos esperar que 2017 tenha as maiores vendas

SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(MONTH FROM occurred_at)=1 AND EXTRACT(DAY FROM occurred_at)=1
GROUP BY year, month, day
ORDER BY total_usd ASC


-- Lets see the percentage of growth in each year
WITH CTE_GROWTH AS 
(SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(MONTH FROM occurred_at)=1 AND EXTRACT(DAY FROM occurred_at)=1
GROUP BY year, month, day
ORDER BY total_usd ASC) 

SELECT year, month, day,total_usd, total_usd - LAG(total_usd) OVER (ORDER BY year ASC) AS growth, 
(total_usd - LAG (total_usd) OVER (ORDER BY year ASC))/LAG (total_usd) OVER (ORDER BY year ASC)*100 AS percentage_growth
FROM CTE_GROWTH



/*11. Em qual mês de qual ano a Walmart gastou mais em papel brilhante em termos de dólares?*/

-- Selecionamos o nome da conta da tabela accounts, extraímos o ano e o mês da coluna occurred_at e aplicamos a função sum()
-- à coluna gloss_amt_usd da tabela orders
-- Fazemos um join entre a tabela accounts e a tabela orders porque precisamos de informações de ambas as tabelas
-- E queremos apenas o que a Walmart gastou, então adicionamos uma condição com a cláusula where
-- Em seguida, agrupamos por account_name, ano e mês
-- E ordenamos tudo pelo total gasto em papel brilhante, e como queremos apenas o ano e o mês em que a Walmart gastou mais, pegamos apenas a primeira linha.

SELECT ac.name AS account_name,  EXTRACT(YEAR FROM o.occurred_at) AS year, EXTRACT(MONTH FROM o.occurred_at) AS month, SUM(o.gloss_amt_usd) AS gloss_total_usd
FROM accounts ac JOIN orders o ON ac.id=o.account_id
WHERE ac.name = 'Walmart'
GROUP BY account_name, year, month
ORDER BY gloss_total_usd DESC
limit 1

