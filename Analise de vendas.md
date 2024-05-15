# Análise de vendas.

A primeira coisa que iremos fazer é verificar quanto vendemos por ano.

````sql
SELECT EXTRACT(YEAR FROM occurred_at) AS year, SUM(total_amt_usd) AS total_usd
FROM orders
GROUP BY year
ORDER BY total_usd ASC
````

year|total_usd  |
----|-----------|
2017|78151.43   |
2013|377331.00  |
2014|4069106.54 |
2015|5752004.94 |
2016|12864917.92|

Obervamos as vendas vem crescendo a cada ano com 2016 sendo o melhor ano do total de vendas, exceto por 2013 e 2017, onde houveram menos vendas. 

A próxima tabela nos mostra que em 2013 e 2017 houve apenas um mês de venda, o que explica não haver crescimento nesses anos.

````sql
SElECT EXTRACT(YEAR FROM occurred_at) AS year, 
EXTRACT(MONTH FROM occurred_at) AS month, SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at)=2013 OR EXTRACT(YEAR FROM occurred_at) = 2017
GROUP BY year, month
ORDER BY year
````

year|month|total_usd|
----|-----|---------|
2013|12	  |377331.00|
2017|1	  |78151.43 |



Olhando mais a fundo, percebemos que apenas houve apenas 2 dias de venda em 2017. Os dias primeiro e segundo de janeiro.

````sql
SElECT EXTRACT(YEAR FROM occurred_at) AS year, 
EXTRACT(MONTH FROM occurred_at) AS month, EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at)=2017
GROUP BY year, month, day
ORDER BY total_usd ASC
````

year|month|day|total_usd|
----|-----|---|---------|
2017|1    |2  |6451.76  |
2017|1    |1  |71699.67 |

Comparando o dia primeiro de janeiro de cada ano, percebe-se um aumento contínuo no aumento das vendas.

````sql
SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(MONTH FROM occurred_at)=1 AND EXTRACT(DAY FROM occurred_at)=1
GROUP BY year, month, day
ORDER BY total_usd ASC
````

year|month|day|total_usd|
----|-----|---|---------|
2014|1    |1  |14850.29 |
2015|1    |1  |23235.79 |
2016|1    |1  |28256.34 |
2017|1    |1  |71699.67 |


Na tabela a baixo veremos o quanto as vendas cresceu a cada ano.

````sql
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
````

year|month|day|total_usd|growth  |percentage_growth        |
----|-----|---|---------|--------|-------------------------|
2014|1    |1  |14850.29	|	     |                         |
2015|1    |1  |23235.79	|8385.50 |56.46691074719752947600  |
2016|1    |1  |28256.34	|5020.55 |21.60696924873223591700  |
2017|1    |1  |71699.67	|43443.33|153.7471944349480500     |

De 2016 à 2017 as vendas cresceram 153\%.

Para cada conta, determinamos a quantidade média de cada tipo de papel que cada empresa comprou em todos os seus pedidos.

````sql
SELECT ac.name AS account_name, AVG(o.standard_qty) AS average_standard_qty, AVG(o.gloss_qty) AS average_gloss_qty, AVG(o.poster_qty) AS average_poster_qty, AVG(total) as average_total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY average_standard_qty DESC
````

account_name             |average_standard_qty |average_gloss_qty   |average_poster_qty  |average_total        |
-------------------------|---------------------|--------------------|--------------------|---------------------|
State Farm Insurance Cos.|1891.7777777777777778|235.2222222222222222|150.4444444444444444|2277.444444444444444 |
Kohl's                   |1878.2857142857142857|285.7142857142857143|167.4285714285714286|2331.4285714285714286|
Berkshire Hathaway       |1148.0000000000000000|0.000000000000000000|215.0000000000000000|1363.0000000000000000|
Edison International     |756.6000000000000000 |25.2000000000000000	|423.4000000000000000|1205.2000000000000000|
Core-Mark Holding        |743.1607142857142857 |35.4821428571428571	|20.4642857142857143 |799.1071428571428571 |

A empresa que comprou uma maior quantidade de papel foi *State Farm Insurance Cos.*

Vamos calcular a quantia média gasta por pedido para cada tipo de papel.

````sql
SELECT ac.name AS account_name, AVG(o.standard_amt_usd) AS avg_standard_amt_usd, AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd,
AVG(o.poster_amt_usd) AS avg_poster_amt_usd, AVG(o.standard_amt_usd)+AVG(o.gloss_amt_usd)+AVG(o.poster_amt_usd) as total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY total DESC
````

account_name               |avg_standard_amt_usd |avg_gloss_amt_usd     |avg_poster_amt_usd   |total                    |
---------------------------|---------------------|----------------------|---------------------|-------------------------|
Pacific Life               |1675.1046153846153846|227.0046153846153846	|17737.827692307692   |19639.9369230769227692   |
Fidelity National Financial|2015.9600000000000000|120.7762500000000000	|11616.675000000000   |13753.4112500000000000   |
Kohl's	                   |9372.6457142857142857|2140.0000000000000000	|1359.5200000000000000|12872.1657142857142857   |
State Farm Insurance Cos.  |9439.9711111111111111|1761.8144444444444444	|1221.6088888888888889|12423.3944444444444444   |
AmerisourceBergen          |888.2200000000000000 |1964.2525000000000000	|6832.9800000000000000|9685.4525000000000000    |


Na tabela acima observamos que a empresa *Pacific Life* foi a que mais comprou, seguida por *Fidelity National Financial.*
Com um comando análogo, observamos a empresa que menos comprou papel, neste caso, a *Nike.*

Se estivermos interessado em um tipo específico de papel, nós podemos ordernar a tabela anterior. Supomos que estamos interessando em Standard paper, então ordenamos por avg_standard_amt_usd, dessa forma, podemos ver qual empresa mais gastou nesse tipo de papel.

Por hora, vamos verificar quanto de papel foi vendido.

````sql
SELECT SUM(standard_qty) AS total_standard_qty, 
SUM(gloss_qty) AS total_gloss_qty, 
SUM(poster_qty) AS total_poster_qty, 
FROM orders
````

total_standard_quantity|total_gloss_quantity|total_poster_quantity|
-----------------------|--------------------|---------------------|
1938346	               |1013773	            |723646	              |


````sql
SELECT SUM(standard_qty) AS total_standard_qty, 
SUM(standard_amt_usd) AS total_standard_usd, 
SUM(gloss_amt_usd) total_gloss_usd, 
SUM(poster_amt_usd) AS  total_poster_usd 
FROM orders
````

total_standard_usd|total_gloss_usd |total_poster_usd|
------------------|----------------|----------------|
9672346.54	      |7593159.77      |5876005.52      |

Das duas tabelas acima, temos que o tipo de papel mais vendido é o Standard paper

Vamos verificar o preço da unidade que cada empresa pagou por pedido, mas apenas daquelas que compraram mais de 100 standard papers e 50 poster papers.

````sql
SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price ASC
````

region   |account_name             |unit_price        |
---------|-------------------------|------------------|
Northeast|State Farm Insurance Cos.|5.1192822502542913|
Southeast|DISH Network             |5.2318158475403638|
Northeast|Travelers Cos.           |5.2351813313106532|
Northeast|Best Buy                 |5.2604264379300265|
West     |Stanley Black & Decker   |5.2663955600739988|


````sql
SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC
````

region   |account_name               |unit_price        |
---------|---------------------------|------------------|
Northeast|IBM                        |8.0899060822781456|
West     |Mosaic                     |8.0663292103581285|
West     |Pacific Life               |8.0630226525147913|
Northeast|CHS                        |8.0188493267801133|
West     |Fidelity National Financial|7.9928024668468328|

O menor preço da unidade foi de 5.11 USD que corresponde a *State Farm Insurance Cos.*, enquanto o maior preço da unidade foi de 8.08 USD, correspondente a *IBM.*

Sabendo que o preço da unidade é importante pois permite ao comprador entender como o total de vendas foi calculado. Isto é, é uma questão de transparência prover toda informação necessária para o consumidor.

Nós podemos também usar o preõ da unidade para ter uma ideia do custo de produção para um certo tipo de papel. Similarmente, podemos comparar o preço da unidade com o dos competidores.

## Conclusão
1. Ano a ano houve um aumento estável de vendas com um aumento de mais de 100% de 2016 à 2017
2. É esperado que em 2017 tenha a maior quantidade de vendas
3. O maior cliente é *Pacific Life* seguido por *Fidelity National Financial.*
4. O tipo de papel mais vendido é o standard paper
5. O maior preço unitário é de 8.08 USD correspondente a *IBM.*



