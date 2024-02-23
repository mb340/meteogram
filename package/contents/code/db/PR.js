const CITIES = [
	"001	Adjuntas	18.16274	-66.72212	501	295",
	"003	Aguada	18.37939	-67.18824	20	295",
	"003	Luyando	18.36439	-67.1574	39	295",
	"005	Aguadilla	18.42745	-67.15407	7	295",
	"005	Caban	18.44328	-67.13601	173	295",
	"005	Rafael Hernandez	18.47133	-67.07907	109	295",
	"005	San Antonio	18.49217	-67.09851	69	295",
	"007	Aguas Buenas	18.2569	-66.10294	259	295",
	"007	Santa Clara	18.21857	-66.12878	450	295",
	"007	Sumidero	18.21857	-66.12878	450	295",
	"009	Aibonito	18.13996	-66.266	607	295",
	"009	Pastos	18.11774	-66.25878	655	295",
	"011	Añasco	18.28273	-67.13962	14	295",
	"011	Espino	18.27634	-67.11935	27	295",
	"011	La Playa	18.28745	-67.18685	3	295",
	"011	Las Marias	18.29328	-67.14629	14	295",
	"013	Animas	18.4455	-66.6349	59	295",
	"013	Arecibo	18.47245	-66.71573	14	295",
	"013	Bajadero	18.42661	-66.68323	25	295",
	"013	La Alianza	18.39745	-66.6024	170	295",
	"013	Sabana Hoyos	18.43384	-66.61378	98	295",
	"015	Arroyo	17.9658	-66.06128	7	295",
	"015	Buena Vista	17.99635	-66.05183	55	295",
	"015	Palmas	17.98719	-66.02544	68	295",
	"015	Yaurel	18.02691	-66.05711	210	295",
	"017	Barceloneta	18.4505	-66.53851	9	295",
	"017	Bufalo	18.41828	-66.57323	135	295",
	"017	Garrochales	18.45356	-66.56628	17	295",
	"017	Imbery	18.43689	-66.55239	57	295",
	"017	Tiburones	18.43161	-66.58073	93	295",
	"019	Barranquitas	18.18662	-66.30628	603	295",
	"021	Bayamón	18.39856	-66.15572	20	295",
	"023	Betances	18.02857	-67.1349	20	295",
	"023	Boquerón	18.02691	-67.16907	8	295",
	"023	Cabo Rojo	18.08663	-67.14573	27	295",
	"023	Monte Grande	18.08746	-67.1074	29	295",
	"023	Pole Ojea	17.97496	-67.18518	15	295",
	"023	Puerto Real	18.07496	-67.18712	8	295",
	"025	Bairoa	18.25912	-66.04044	64	295",
	"025	Caguas	18.23412	-66.0485	65	295",
	"027	Camuy	18.48383	-66.8449	14	295",
	"027	Piedra Gorda	18.43411	-66.88768	180	295",
	"027	Quebrada	18.35662	-66.83212	311	295",
	"029	Benitez	18.27357	-65.87905	400	295",
	"029	Campo Rico	18.33717	-65.89794	161	295",
	"029	Canovanas	18.3751	-65.89934	15	295",
	"029	Lomas	18.26857	-65.90878	244	295",
	"029	San Isidro	18.39217	-65.88544	12	295",
	"029	Santa Barbara	18.39356	-65.91878	18	295",
	"031	Carolina	18.38078	-65.95739	22	295",
	"033	Cataño	18.44134	-66.11822	1	295",
	"035	Cayey	18.11191	-66.166	397	295",
	"035	G. L. Garcia	18.12746	-66.10405	443	295",
	"037	Aguas Claras	18.25273	-65.6535	34	295",
	"037	Ceiba	18.26412	-65.6485	24	295",
	"039	Ciales	18.33606	-66.46878	93	295",
	"041	Bayamon	18.17774	-66.11322	445	295",
	"041	Cidra	18.17579	-66.16128	426	295",
	"041	Parcelas La Milagrosa	18.17079	-66.18822	552	295",
	"041	Parcelas Nuevas	18.14024	-66.17239	424	295",
	"043	Coamo	18.07996	-66.35795	126	295",
	"043	Los Llanos	18.05524	-66.40573	140	295",
	"043	Mariano Colón	18.0233	-66.33239	111	295",
	"043	Palmarejo	18.06802	-66.32545	241	295",
	"045	Comerío	18.21801	-66.226	202	295",
	"045	Palomas	18.23246	-66.25628	597	295",
	"047	Corozal	18.34106	-66.31684	97	295",
	"049	Culebra	18.30301	-65.30099	7	295",
	"051	Dorado	18.45883	-66.26767	8	295",
	"051	Río Lajas	18.39467	-66.26767	136	295",
	"051	San Antonio	18.44884	-66.30267	7	295",
	"053	Fajardo	18.32579	-65.65238	16	295",
	"053	Luis M. Cintron	18.29968	-65.63849	27	295",
	"054	Estancias de Florida	18.36662	-66.56962	200	295",
	"054	Florida	18.36245	-66.56128	193	295",
	"054	Pajonal	18.38217	-66.55573	179	295",
	"055	Fuig	17.98774	-66.91601	6	295",
	"055	Guánica	17.97163	-66.90795	7	295",
	"055	Maria Antonia	17.9783	-66.88934	43	295",
	"057	Corazón	17.99274	-66.08489	62	295",
	"057	Guayama	17.98413	-66.11378	74	295",
	"057	Jobos	17.95524	-66.16544	7	295",
	"057	Olimpo	18.00191	-66.10822	94	295",
	"059	Guayanilla	18.01913	-66.79184	16	295",
	"059	Indios	17.99413	-66.81934	45	295",
	"059	Magas Arriba	18.01746	-66.76906	31	295",
	"061	Guaynabo	18.35745	-66.111	50	295",
	"063	Celada	18.27162	-65.966	84	295",
	"063	Gurabo	18.2544	-65.97294	68	295",
	"065	Carrizales	18.48189	-66.7899	32	295",
	"065	Corcovado	18.45856	-66.77629	87	295",
	"065	Hatillo	18.48633	-66.82545	9	295",
	"065	Rafael Capo	18.40717	-66.78212	186	295",
	"065	Rafael Gonzalez	18.42745	-66.78684	130	295",
	"067	Hormigueros	18.13968	-67.1274	28	295",
	"069	Antón Ruiz	18.18524	-65.8085	31	295",
	"069	Bajandas	18.15774	-65.78155	38	295",
	"069	Candelero Arriba	18.10191	-65.83683	73	295",
	"069	Humacao	18.14968	-65.82738	25	295",
	"069	Punta Santiago	18.16635	-65.74822	4	295",
	"071	Isabela	18.50078	-67.02435	76	295",
	"071	Mora	18.463	-67.03268	138	295",
	"073	Jayuya	18.21857	-66.59156	441	295",
	"075	Aguilita	18.0233	-66.53462	29	295",
	"075	Capitanejo	18.01454	-66.53372	19	295",
	"075	Guayabal	18.08135	-66.50128	79	295",
	"075	Juana Díaz	18.05246	-66.50656	50	295",
	"075	Luis Llorens Torres	18.05691	-66.52684	81	295",
	"075	Potala Pastillo	17.99135	-66.49656	4	295",
	"075	Río Cañas Abajo	18.0383	-66.46767	72	295",
	"077	El Mangó	18.23412	-65.87961	93	295",
	"077	Juncos	18.22746	-65.921	68	295",
	"079	Lajas	18.04996	-67.05934	58	295",
	"079	La Parguera	17.97497	-67.04657	11	295",
	"079	Palmarejo	18.04024	-67.07685	48	295",
	"081	Lares	18.29467	-66.87712	349	295",
	"083	Las Marías	18.2519	-66.99212	300	295",
	"085	Boqueron	18.20746	-65.8485	102	295",
	"085	La Fermina	18.17551	-65.8535	130	295",
	"085	Las Piedras	18.18301	-65.86627	136	295",
	"085	Pueblito del Rio	18.22801	-65.86294	83	295",
	"087	Loíza	18.43134	-65.88016	4	295",
	"087	Suárez	18.43022	-65.8535	3	295",
	"087	Vieques	18.42495	-65.83294	4	295",
	"089	Luquillo	18.37245	-65.71655	12	295",
	"089	Playa Fortuna	18.37967	-65.74516	7	295",
	"089	Ramos	18.33967	-65.71266	51	295",
	"091	La Luisa	18.44884	-66.50989	17	295",
	"091	Manatí	18.42745	-66.49212	33	295",
	"091	Tierras Nuevas Poniente	18.46189	-66.4885	25	295",
	"093	Maricao	18.18079	-66.9799	436	295",
	"095	Emajagua	18.00052	-65.88266	22	295",
	"095	Maunabo	18.00719	-65.89933	13	295",
	"095	Palo Seco	18.00747	-65.93683	77	295",
	"097	Mayagüez	18.20107	-67.13962	27	295",
	"099	Aceitunas	18.44328	-67.0649	184	295",
	"099	Moca	18.39467	-67.11324	49	295",
	"101	Barahona	18.35134	-66.44545	166	295",
	"101	Franquez	18.34023	-66.42767	181	295",
	"101	Morovis	18.32578	-66.40656	219	295",
	"103	Daguao	18.22635	-65.68322	35	295",
	"103	Duque	18.23669	-65.74172	75	295",
	"103	Naguabo	18.21162	-65.73488	20	295",
	"103	Peña Pobre	18.21551	-65.82211	103	295",
	"103	Río Blanco	18.21829	-65.7885	17	295",
	"105	Naranjito	18.30079	-66.24489	114	295",
	"107	Orocovis	18.2269	-66.391	514	295",
	"109	Lamboglia	17.98136	-65.98572	35	295",
	"109	Patillas	18.00635	-66.01572	21	295",
	"111	Peñuelas	18.05635	-66.72156	61	295",
	"111	Santo Domingo	18.0633	-66.7524	141	295",
	"111	Tallaboa	17.99497	-66.71629	21	295",
	"111	Tallaboa Alta	18.05107	-66.70017	89	295",
	"113	Coto Laurel	18.04969	-66.55128	71	295",
	"113	Marueño	18.05772	-66.65603	136	295",
	"113	Ponce	18.01031	-66.62398	12	295",
	"115	Cacao	18.43661	-66.93712	241	295",
	"115	Quebradillas	18.47383	-66.93851	119	295",
	"115	San Antonio	18.45161	-66.94962	164	295",
	"117	Rincón	18.34023	-67.2499	15	295",
	"117	Stella	18.32189	-67.24685	8	295",
	"119	Bartolo	18.36134	-65.8385	60	295",
	"119	Hato Candal	18.37439	-65.78711	40	295",
	"119	La Dolores	18.3755	-65.85572	19	295",
	"119	Palmer	18.37051	-65.77405	19	295",
	"119	Río Grande	18.38023	-65.83127	16	295",
	"121	Liborio Negron Torres	18.04302	-66.9424	64	295",
	"121	Lluveras	18.0383	-66.90462	100	295",
	"121	Sabana Grande	18.07774	-66.96045	98	295",
	"123	Central Aguirre	17.95358	-66.22294	9	295",
	"123	Coco	18.00719	-66.25933	43	295",
	"123	Coquí	17.97413	-66.22711	9	295",
	"123	La Plena	18.04663	-66.20461	183	295",
	"123	Las Ochenta	17.98469	-66.31795	14	295",
	"123	Playita	17.96052	-66.28961	2	295",
	"123	Salinas	17.97747	-66.29795	9	295",
	"123	Vázquez	18.0658	-66.2385	157	295",
	"125	Sabana Eneas	18.08607	-67.08101	34	295",
	"125	San Germán	18.08163	-67.0449	69	295",
	"127	San Juan	18.46633	-66.10572	11	295",
	"129	Jagual	18.16163	-65.99544	208	295",
	"129	San Lorenzo	18.1894	-65.961	97	295",
	"131	Hato Arriba	18.35578	-67.03407	70	295",
	"131	Juncal	18.31384	-66.91907	359	295",
	"131	San Sebastián	18.33662	-66.99018	83	295",
	"133	El Ojo	18.00385	-66.39156	33	295",
	"133	Jauca	17.96913	-66.36572	2	295",
	"133	Las Ollas	18.014	-66.421	54	295",
	"133	Parcelas Peñuelas	17.99885	-66.34128	43	295",
	"133	Playita Cortada	17.98497	-66.43906	6	295",
	"133	Santa Isabel	17.96608	-66.40489	6	295",
	"135	Galateo	18.36245	-66.25878	29	295",
	"135	H. Rivera Colon	18.34773	-66.27378	142	295",
	"135	Mucarabones	18.39078	-66.216	35	295",
	"135	Pájaros	18.36856	-66.21683	53	295",
	"135	Toa Alta	18.38828	-66.24822	25	295",
	"137	Campanilla	18.42134	-66.23683	8	295",
	"137	Candelaria	18.40411	-66.20878	74	295",
	"137	Candelaria Arenas	18.41717	-66.21739	36	295",
	"137	Ingenio	18.44217	-66.226	5	295",
	"137	Levittown	18.44995	-66.18156	3	295",
	"137	Sabana Seca	18.42689	-66.18461	16	295",
	"137	San José	18.39828	-66.25572	18	295",
	"137	Toa Baja	18.44384	-66.25961	6	295",
	"139	Trujillo Alto	18.35467	-66.00739	21	295",
	"141	Cayuco	18.29106	-66.73934	431	295",
	"141	Utuado	18.26551	-66.70045	145	295",
	"143	Brenas	18.46717	-66.341	7	295",
	"143	Ceiba	18.44634	-66.35073	8	295",
	"143	Vega Alta	18.41217	-66.33128	34	295",
	"145	Coto Norte	18.43078	-66.43989	81	295",
	"145	Miranda	18.38662	-66.38378	149	295",
	"145	Monserrate	18.43661	-66.35961	40	295",
	"145	Sabana	18.46078	-66.3585	5	295",
	"145	Vega Baja	18.44439	-66.38767	12	295",
	"147	Esperanza	18.09719	-65.47071	8	295",
	"147	Isabel Segunda	18.14913	-65.44266	16	295",
	"149	Villalba	18.12718	-66.49212	159	295",
	"151	Comunas	18.08719	-65.84377	49	295",
	"151	El Negro	18.03747	-65.85127	41	295",
	"151	Martorell	18.07607	-65.89822	27	295",
	"151	Playita	18.04469	-65.90738	28	295",
	"151	Rosa Sanchez	18.06163	-65.9135	30	295",
	"151	Yabucoa	18.05052	-65.87933	27	295",
	"153	Palomas	18.01358	-66.87323	44	295",
	"153	Yauco	18.03496	-66.8499	46	295",
];
