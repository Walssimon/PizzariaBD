--Walssimon do Santos Silva Sacramento e Wersington do Santos Silva Sacramento

DROP database pizzaria;

CREATE database pizzaria;

use pizzaria;

CREATE TABLE clientes (
codcliente INT NOT NULL PRIMARY KEY,
nomecliente VARCHAR(50) NOT NULL,
rua VARCHAR(100) NOT NULL,
cep	 VARCHAR(9) NOT NULL,
compl VARCHAR(100) NULL,
bairro VARCHAR(30) NOT NULL,
telefone VARCHAR(14) NOT NULL
); 

CREATE TABLE pizzas (
codpizza INT NOT NULL PRIMARY KEY,
nomepizza VARCHAR(50) NOT NULL,
ingredientes VARCHAR(150) NOT NULL,
tamanho VARCHAR(7) NOT NULL,
precopizza DECIMAL(6,2) NOT NULL
);

CREATE TABLE bebidas (
codbebidas INT NOT NULL PRIMARY KEY,
nomebebida VARCHAR(30) NOT NULL,
peso INT NOT NULL,
precobebida DECIMAL(6,2) NOT NULL
);

CREATE TABLE pedidos (
codpedido INT  NOT NULL PRIMARY KEY,
datapedido DATE NOT NULL,
codcliente INT NOT NULL,

CONSTRAINT fk_codcliente_clientes FOREIGN KEY (codcliente) REFERENCES clientes(codcliente)
);

CREATE TABLE pizzaspedidas (
codpedido INT NOT NULL,
codpizza INT NOT NULL,
quantidade INT NOT NULL,

CONSTRAINT fk_codpedido_pedidos FOREIGN KEY (codpedido) REFERENCES pedidos(codpedido),
CONSTRAINT fk_codpizza_pizzas FOREIGN KEY (codpizza) REFERENCES pizzas(codpizza)
);

CREATE TABLE bebidaspedidas (
codpedido INT NOT NULL,
codbebidas INT NOT NULL,
quantidade INT NOT NULL,

CONSTRAINT fk_codpedidos_pedidos FOREIGN KEY (codpedido) REFERENCES pedidos(codpedido),
CONSTRAINT fk_codbebidas_bebidas FOREIGN KEY (codbebidas) REFERENCES bebidas(codbebidas)
);

INSERT INTO clientes 

VALUES (1,'Mario Mario', 'Rua cogumelo verde', '88745967', 'M', 'Reino dos cogumelos', '9295562746'),
(2,'Sonic Hedgehog', 'Rua zone 1', '26553174', 'S', 'Green Hills', '915460078'),
(3,'Howl Cagliostro', 'Rua Reino do norte', '04895612', 'K', 'Castelo Animado', '974805647'),
(4,'Spyro Arigator', 'Rua Encantada', '46995145', null , 'Reino dos Dragoes', '941527486'),
(5,'Xudravino dos Santos', 'Rua Pele', '04880165', '99', 'Pacaembu', '959797906');

INSERT INTO pizzas 

VALUES(1, 'Cogumelo' , 'Cogumelo,Queijo,Couve-FLor,Folha de Loro', 'Grande', '64.00'),
(2, 'HotDog' , 'Salcicha,Queijo,Repolho,Pure,Batatapalha,Vinagrete,Milho,Ervilha', 'Medio', '32.00'),
(3, 'Ovo Com Bacon' , 'Ovo,Queijo,Bacon', 'Broto', '23.50'),
(4, 'Bala Infinito' , 'Cafe da Manha,Almoco,Janta', 'Broto', '11.00'),
(5, 'Brasileira' , 'Mussarela,Presunto,Azeitona,Catupiry,Frango', 'Grande', '73.00');

INSERT INTO bebidas 

VALUES(1, 'Coca Cola' , 3, '13.00'),
(2, 'Dolly' , 2,'5.80'),
(3, 'Guaraviton' , '1', '6.00');

INSERT INTO pedidos 

VALUES(1, "20230509",3),
(2, "20230508",2),
(3, "20230416",4),
(4, "20230423",5),
(5, "20230430",1);

INSERT INTO pizzaspedidas

VALUES(1,3,3),
(1,5,1),
(1,1,1),
(2,2,3),
(2,4,1),
(2,1,1),
(3,5,2),
(3,4,1),
(4,3,2),
(4,5,2),
(4,2,1),
(5,1,3),
(5,3,1);


INSERT INTO bebidaspedidas

VALUES(1,1,1),
(2,2,1),
(3,3,1),
(4,3,1),
(5,1,1);

CREATE TEMPORARY TABLE tmp_subtotalpizza (
nomepizza VARCHAR (150) NOT NULL,
subtotal DECIMAL(6,2) NOT NULL
);

INSERT INTO tmp_subtotalpizza (nomepizza, subtotal)
SELECT pi.nomepizza,
quantidade * pi.precopizza AS subtotal
FROM pizzas pi INNER JOIN pizzaspedidas pp INNER JOIN pedidos p ON pp.codpedido= p.codpedido
GROUP BY pi.nomepizza
ORDER BY pi.nomepizza;

SELECT * FROM tmp_subtotalpizza;

DROP TABLE tmp_subtotalbebida;

CREATE TEMPORARY TABLE tmp_subtotalbebida (
nomebebida VARCHAR (150) NOT NULL,
codpedido INT NOT NULL,
subtotalbebida DECIMAL(6,2) NOT NULL
);

INSERT INTO tmp_subtotalbebida (nomebebida,codpedido, subtotalbebida)
SELECT be.nomebebida, p.codpedido,
be.precobebida * bp.quantidade AS subtotalbebida
FROM bebidas be INNER JOIN (pedidos p INNER JOIN bebidaspedidas bp ON p.codpedido = bp.codpedido) ON be.codbebidas = bp.codbebidas
ORDER BY p.codpedido;

SELECT * FROM tmp_subtotalbebida;

CREATE TEMPORARY TABLE tmp_pedido AS
SELECT pedidos.codpedido, pedidos.datapedido, clientes.nomecliente,
       SUM(bebidas.precobebida * bebidaspedidas.quantidade) + 
       SUM(pizzas.precopizza * pizzaspedidas.quantidade) AS totalgeral
FROM pedidos
JOIN clientes ON pedidos.codcliente = clientes.codcliente
LEFT JOIN pizzaspedidas ON pedidos.codpedido = pizzaspedidas.codpedido
LEFT JOIN pizzas ON pizzaspedidas.codpizza = Pizzas.codpizza
LEFT JOIN bebidaspedidas ON pedidos.codpedido = bebidaspedidas.codpedido
LEFT JOIN bebidas ON bebidaspedidas.codbebidas = bebidas.codbebidas
GROUP BY pedidos.codpedido;



SELECT * FROM tmp_pedido;

