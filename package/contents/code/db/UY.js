const CITIES = [
	"01	Artigas	-30.4	-56.46667	113	407",
	"01	Baltasar Brum	-30.71905	-57.32596	144	407",
	"01	Bella Unión	-30.25966	-57.59919	53	407",
	"01	Las Piedras	-30.26204	-57.58174	68	407",
	"01	Pueblo Sequeira	-30.9892	-56.87044	153	407",
	"01	Tomás Gomensoro	-30.4287	-57.43609	94	407",
	"02	Aguas Corrientes	-34.52194	-56.39361	14	407",
	"02	Atlántida	-34.7719	-55.7584	22	407",
	"02	Barra de Carrasco	-34.87722	-56.02972	4	407",
	"02	Barros Blancos	-34.7524	-56.00259	34	407",
	"02	Canelones	-34.52278	-56.27778	18	407",
	"02	Colonia Nicolich	-34.81516	-56.02435	16	407",
	"02	Empalme Olmos	-34.69753	-55.89268	39	407",
	"02	Joaquín Suárez	-34.73501	-56.0347	58	407",
	"02	Juanicó	-34.59454	-56.25334	43	407",
	"02	La Floresta	-34.75572	-55.68141	18	407",
	"02	La Paz	-34.76031	-56.2259	57	407",
	"02	Las Piedras	-34.7302	-56.21915	72	407",
	"02	Las Toscas	-34.73333	-55.71667	2	407",
	"02	Los Cerrillos	-34.605	-56.35639	41	407",
	"02	Migues	-34.48759	-55.62793	79	407",
	"02	Montes	-34.49339	-55.56219	39	407",
	"02	Pando	-34.71716	-55.9584	23	407",
	"02	Paso de Carrasco	-34.86028	-56.05222	9	407",
	"02	Progreso	-34.66737	-56.21758	56	407",
	"02	San Antonio	-34.4513	-56.08036	52	407",
	"02	San Bautista	-34.44016	-55.95861	74	407",
	"02	San Jacinto	-34.54465	-55.87151	61	407",
	"02	San Ramón	-34.29155	-55.95571	44	407",
	"02	Santa Lucía	-34.45333	-56.39056	24	407",
	"02	Santa Rosa	-34.49819	-56.03795	58	407",
	"02	Sauce	-34.65191	-56.06431	42	407",
	"02	Soca	-34.68432	-55.702	11	407",
	"02	Tala	-34.34349	-55.76375	84	407",
	"02	Toledo	-34.73807	-56.09469	64	407",
	"03	Aceguá	-31.87178	-54.16351	279	407",
	"03	Isidoro Noblía	-31.96218	-54.12309	137	407",
	"03	Melo	-32.37028	-54.1675	115	407",
	"03	Río Branco	-32.59802	-53.38583	9	407",
	"03	Tupambaé	-32.83333	-54.76667	289	407",
	"04	Carmelo	-34.00023	-58.28402	13	407",
	"04	Colonia del Sacramento	-34.46262	-57.83976	30	407",
	"04	Colonia Valdense	-34.33957	-57.26246	41	407",
	"04	Florencio Sánchez	-33.87785	-57.37166	177	407",
	"04	Juan L. Lacaze	-34.41888	-57.45285	15	407",
	"04	Miguelete	-34.00646	-57.64792	120	407",
	"04	Nueva Helvecia	-34.3	-57.23333	52	407",
	"04	Nueva Palmira	-33.87031	-58.41176	8	407",
	"04	Ombúes de Lavalle	-33.93783	-57.80959	110	407",
	"04	Rosario	-34.31667	-57.35	26	407",
	"04	Santa Teresa	-34.43333	-57.71667	20	407",
	"04	Tarariras	-34.26555	-57.61866	92	407",
	"05	Blanquillo	-32.76667	-55.63333	91	407",
	"05	Carlos Reyles	-33.05658	-56.47652	140	407",
	"05	Durazno	-33.38056	-56.52361	93	407",
	"05	La Paloma	-32.72689	-55.5827	147	407",
	"05	Pueblo Centenario	-32.86667	-56.46667	71	407",
	"05	Santa Bernardina	-33.3536	-56.52498	79	407",
	"05	Sarandí del Yi	-33.35	-55.63333	126	407",
	"05	Villa del Carmen	-33.23943	-56.00936	160	407",
	"06	Trinidad	-33.5165	-56.89957	142	407",
	"07	25 de Agosto	-34.41167	-56.40222	25	407",
	"07	25 de Mayo	-34.18917	-56.33944	58	407",
	"07	Alejandro Gallinal	-33.86252	-55.54264	235	407",
	"07	Cardal	-34.29056	-56.38889	53	407",
	"07	Casupá	-34.09994	-55.64811	125	407",
	"07	Florida	-34.09556	-56.21417	74	407",
	"07	Sarandí Grande	-33.73333	-56.33333	132	407",
	"08	José Batlle y Ordóñez	-33.46667	-55.11667	293	407",
	"08	José Pedro Varela	-33.45451	-54.53586	72	407",
	"08	Mariscala	-34.04085	-54.77732	92	407",
	"08	Minas	-34.37589	-55.23771	134	407",
	"08	Solís de Mataojo	-34.59951	-55.46808	40	407",
	"08	Zapicán	-33.52284	-54.94221	223	407",
	"09	Aiguá	-34.20498	-54.75665	94	407",
	"09	Maldonado	-34.9	-54.95	30	407",
	"09	Pan de Azúcar	-34.7787	-55.23582	22	407",
	"09	Piriápolis	-34.86287	-55.27471	17	407",
	"09	Punta del Este	-34.94747	-54.93382	15	407",
	"09	San Carlos	-34.79123	-54.91824	28	407",
	"10	Montevideo	-34.90328	-56.18816	34	407",
	"10	Pajas Blancas	-34.80167	-56.33417	24	407",
	"10	Santiago Vázquez	-34.79028	-56.35	13	407",
	"11	Chapicuy	-31.66048	-57.88809	48	407",
	"11	Estación Porvenir	-32.37085	-57.85371	79	407",
	"11	Gallinal	-31.8847	-57.48016	118	407",
	"11	Guichón	-32.35846	-57.19778	94	407",
	"11	Merinos	-32.38486	-56.90429	171	407",
	"11	Paysandú	-32.3171	-58.08072	44	407",
	"11	Piedras Coloradas	-32.37183	-57.60901	91	407",
	"11	Porvenir	-32.39273	-57.96961	60	407",
	"11	Quebracho	-31.93526	-57.9014	66	407",
	"11	San Félix	-32.34631	-58.10094	11	407",
	"12	Algorta	-32.42124	-57.38929	122	407",
	"12	Fray Bentos	-33.11651	-58.31067	17	407",
	"12	Nuevo Berlín	-32.97974	-58.05858	11	407",
	"12	San Javier	-32.66523	-58.1332	13	407",
	"12	Young	-32.69844	-57.62693	86	407",
	"13	Minas de Corrales	-31.57375	-55.47075	166	407",
	"13	Rivera	-30.90534	-55.55076	194	407",
	"13	Tranqueras	-31.2	-55.75	187	407",
	"13	Vichadero	-31.77794	-54.69183	241	407",
	"14	Castillos	-34.19871	-53.85919	33	407",
	"14	Cebollatí	-33.26703	-53.79425	12	407",
	"14	Chui	-33.69792	-53.45926	16	407",
	"14	Costa Azul	-34.62925	-54.15307	8	407",
	"14	Dieciocho de Julio	-33.68216	-53.55325	13	407",
	"14	General Enrique Martínez	-33.20388	-53.80524	10	407",
	"14	La Coronilla	-33.55791	-53.85803	14	407",
	"14	La Paloma	-34.66268	-54.16452	7	407",
	"14	Lascano	-33.67235	-54.2065	45	407",
	"14	Rocha	-34.48333	-54.33333	30	407",
	"14	Velázquez	-34.03631	-54.28054	66	407",
	"15	Albisu	-31.38411	-57.81469	60	407",
	"15	Belén	-30.78716	-57.77577	44	407",
	"15	Colonia Lavalleja	-31.09386	-57.02332	125	407",
	"15	Salto	-31.38333	-57.96667	18	407",
	"15	Villa Constitución	-31.06913	-57.84946	47	407",
	"16	Capurro	-34.43662	-56.46447	36	407",
	"16	Delta del Tigre	-34.76488	-56.3645	5	407",
	"16	Ecilda Paullier	-34.35778	-57.04883	74	407",
	"16	Ituzaingó	-34.42028	-56.42488	21	407",
	"16	Libertad	-34.63459	-56.61739	40	407",
	"16	Puntas de Valdéz	-34.5855	-56.70097	50	407",
	"16	Rafael Perazza	-34.52335	-56.7971	40	407",
	"16	Rodríguez	-34.381	-56.53797	48	407",
	"16	San José de Mayo	-34.3375	-56.71361	52	407",
	"17	Agraciada	-33.80981	-58.26669	62	407",
	"17	Cardona	-33.87049	-57.36954	170	407",
	"17	Dolores	-33.53009	-58.21701	22	407",
	"17	José Enrique Rodó	-33.69618	-57.53153	140	407",
	"17	Mercedes	-33.2524	-58.03047	29	407",
	"17	Palmitas	-33.50719	-57.80079	90	407",
	"17	Santa Catalina	-33.791	-57.48824	153	407",
	"17	Villa Soriano	-33.39811	-58.32177	5	407",
	"18	Curtina	-32.15	-56.11667	122	407",
	"18	Paso Bonilla	-31.80763	-55.97929	130	407",
	"18	Paso de los Toros	-32.81667	-56.51667	57	407",
	"18	Tacuarembó	-31.71694	-55.98111	135	407",
	"18	Tambores	-31.87743	-56.24438	272	407",
	"19	Santa Clara de Olimar	-32.92254	-54.94447	294	407",
	"19	Treinta y Tres	-33.23333	-54.38333	52	407",
	"19	Vergara	-32.94419	-53.9381	36	407",
	"19	Villa Sara	-33.2534	-54.41947	37	407",
];
