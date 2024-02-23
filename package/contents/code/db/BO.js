const CITIES = [
	"01	Azurduy	-20.10613	-64.41398	2492	59",
	"01	Camargo	-20.64064	-65.20893	2412	59",
	"01	Camatindi	-20.98333	-63.43333	854	59",
	"01	Carandayti	-20.75	-63.06667	639	59",
	"01	Chaunaca	-19.01667	-65.46667	2934	59",
	"01	Chuqui Chuqui	-18.81667	-65.06667	2325	59",
	"01	Culpina	-20.82358	-64.94492	2972	59",
	"01	Huajlaya	-20.6	-64.55	2083	59",
	"01	Huata	-19.01667	-65.25	2917	59",
	"01	Huayllas	-19.16972	-65.32611	2692	59",
	"01	La Cueva	-20.93333	-64.9	3212	59",
	"01	Las Carreras	-21.2084	-65.20988	2328	59",
	"01	Las Carreras	-21.25	-65.28333	2512	59",
	"01	Lintaca	-20.76667	-65.33333	3189	59",
	"01	Maragua	-19.04611	-65.42861	3104	59",
	"01	Mojocoya	-18.7641	-64.61978	2348	59",
	"01	Mojotoro	-18.91667	-65.06667	2509	59",
	"01	Monteagudo	-19.79998	-63.95617	1135	59",
	"01	Padilla	-19.30878	-64.30273	2091	59",
	"01	Pilaya	-20.95	-64.75	1614	59",
	"01	Piocera	-18.75	-65.4	2900	59",
	"01	Pocpo	-18.83333	-65.36667	3050	59",
	"01	Potolo	-19.00556	-65.52861	3036	59",
	"01	Presto	-18.92944	-64.93917	2462	59",
	"01	Pulqui	-19.23333	-65.21667	2990	59",
	"01	Rosario del Ingre	-20.58333	-63.9	936	59",
	"01	Salitre	-20.88333	-64.91667	2990	59",
	"01	San Francisco	-20.71667	-64.7	2996	59",
	"01	San Juan	-21.26667	-65.3	2738	59",
	"01	San Pedro	-19.61667	-64.5	2285	59",
	"01	Santa Elena	-20.55	-64.78333	3079	59",
	"01	Sapirangui	-19.93333	-63.78333	1202	59",
	"01	Sotomayor	-19.34	-64.99917	2184	59",
	"01	Sucre	-19.03332	-65.26274	2798	59",
	"01	Tarabuco	-19.18168	-64.91517	3293	59",
	"01	Tomina	-19.18333	-64.53333	2663	59",
	"01	Villa Charcas	-20.72278	-64.88478	2954	59",
	"01	Villa Serrano	-19.12489	-64.32343	2115	59",
	"01	Yamparáez	-19.18929	-65.12329	3096	59",
	"01	Yotala	-19.15861	-65.26417	2511	59",
	"02	Aiquile	-18.20408	-65.18068	2258	59",
	"02	Arani	-17.56854	-65.76883	2749	59",
	"02	Calchani	-17.32276	-66.69131	3016	59",
	"02	Cañada Hornillos	-17.68587	-65.13912	3123	59",
	"02	Capinota	-17.71113	-66.26082	2395	59",
	"02	Chimoré	-16.99417	-65.1533	243	59",
	"02	Cliza	-17.58777	-65.93253	2726	59",
	"02	Cochabamba	-17.3895	-66.1568	2577	59",
	"02	Colcapirhua	-17.3857	-66.23814	2561	59",
	"02	Colomi	-17.35	-65.86667	3444	59",
	"02	Independencia	-17.08389	-66.81804	2638	59",
	"02	Irpa Irpa	-17.71667	-66.26667	2467	59",
	"02	Mizque	-17.94101	-65.34016	2014	59",
	"02	Puerto Villarroel	-16.84286	-64.79996	167	59",
	"02	Punata	-17.54234	-65.83472	2731	59",
	"02	Quillacollo	-17.39228	-66.27838	2559	59",
	"02	Sacaba	-17.39799	-66.03825	2710	59",
	"02	Sipe Sipe	-17.45419	-66.35737	2588	59",
	"02	Tarata	-17.60898	-66.02135	2760	59",
	"02	Tiquipaya	-17.33801	-66.21579	2651	59",
	"02	Totora	-17.72662	-65.1932	2896	59",
	"02	Vinto	-17.39141	-66.31681	2398	59",
	"03	Guayaramerín	-10.8258	-65.3581	136	59",
	"03	Reyes	-14.2952	-67.33624	189	59",
	"03	Riberalta	-11.01026	-66.05257	145	59",
	"03	Rurrenabaque	-14.44125	-67.52781	210	59",
	"03	San Borja	-14.85195	-66.74954	195	59",
	"03	San Ramón	-13.26647	-64.61515	207	59",
	"03	Santa Ana de Yacuma	-13.74406	-65.42688	148	59",
	"03	Santa Rosa de Yacuma	-14.07719	-66.79349	208	59",
	"03	Trinidad	-14.83333	-64.9	159	59",
	"04	Achacachi	-16.04707	-68.68534	3847	59",
	"04	Achocalla	-16.57386	-68.15112	3664	59",
	"04	Amarete	-15.23736	-68.98517	3842	59",
	"04	Batallas	-16.3	-68.53333	3849	59",
	"04	Belen	-17.36667	-67.55	3870	59",
	"04	Campamento Colquiri	-17.39169	-67.12526	4264	59",
	"04	Caranavi	-15.83403	-67.56586	986	59",
	"04	Chulumani	-16.40855	-67.5294	1871	59",
	"04	Coripata	-16.3	-67.6	1688	59",
	"04	Coroico	-16.19386	-67.72998	1575	59",
	"04	Eucaliptus	-17.58333	-67.51667	3734	59",
	"04	Guanay	-15.49756	-67.88332	477	59",
	"04	Huarina	-16.19066	-68.6009	3866	59",
	"04	Huatajata	-16.20886	-68.70041	3823	59",
	"04	Lahuachaca	-17.37692	-67.67488	3913	59",
	"04	Laja	-16.53333	-68.38333	3856	59",
	"04	La Paz	-16.5	-68.15	3782	59",
	"04	Mapiri	-15.25	-68.16667	806	59",
	"04	Mecapaca	-16.66829	-68.01808	2870	59",
	"04	Patacamaya	-17.23611	-67.91443	3874	59",
	"04	Quime	-16.98333	-67.21667	3063	59",
	"04	San Pablo de Tiquina	-16.21795	-68.8428	3823	59",
	"04	San Pedro	-16.23717	-68.85063	4013	59",
	"04	Sorata	-15.77305	-68.64973	2697	59",
	"04	Tiahuanaco	-16.55228	-68.67953	3860	59",
	"04	Viacha	-16.65	-68.3	3870	59",
	"04	Viloco	-16.95	-67.55	3761	59",
	"04	Yumani	-16.03574	-69.14843	3972	59",
	"05	Andamarca	-18.77934	-67.50753	3751	59",
	"05	Challapata	-18.90208	-66.77048	3732	59",
	"05	Cruz de Machacamarca	-18.88395	-68.41989	3726	59",
	"05	Curahuara de Carangas	-17.84265	-68.40877	3977	59",
	"05	Huachacalla	-18.79298	-68.26157	3753	59",
	"05	Huanuni	-18.289	-66.83583	3963	59",
	"05	Machacamarca	-18.17251	-67.02099	3728	59",
	"05	Oruro	-17.98333	-67.15	3936	59",
	"05	Poopó	-18.37978	-66.96896	3711	59",
	"05	Totoral	-18.4957	-66.87397	3900	59",
	"06	Cobija	-11.02671	-68.76918	200	59",
	"06	Nueva Manoa	-9.71828	-65.39544	122	59",
	"07	Atocha	-20.93515	-66.22139	3675	59",
	"07	Betanzos	-19.55293	-65.45395	3329	59",
	"07	Colchani	-20.3	-66.93333	3668	59",
	"07	Colquechaca	-18.70031	-66.00397	4170	59",
	"07	Llallagua	-18.42494	-66.57778	3750	59",
	"07	Potosí	-19.58361	-65.75306	3967	59",
	"07	Santa Bárbara	-20.91667	-66.05	4732	59",
	"07	Tupiza	-21.44345	-65.71875	2961	59",
	"07	Uyuni	-20.45967	-66.82503	3673	59",
	"07	Villazón	-22.08659	-65.59422	3455	59",
	"08	Abapó Viejo	-18.88562	-63.3829	320	59",
	"08	Ascención de Guarayos	-15.89299	-63.18855	248	59",
	"08	Ascensión	-15.7	-63.08333	198	59",
	"08	Boyuibe	-20.43274	-63.2823	913	59",
	"08	Buena Vista	-17.4583	-63.67126	370	59",
	"08	Camiri	-20.04063	-63.52396	761	59",
	"08	Charagua	-19.79028	-63.19775	711	59",
	"08	Comarapa	-17.91537	-64.53163	1818	59",
	"08	Concepción	-16.43333	-60.9	478	59",
	"08	Cotoca	-17.74959	-62.83442	318	59",
	"08	Cotoca	-17.81667	-63.05	387	59",
	"08	El Torno	-18.00014	-63.38712	572	59",
	"08	Jorochito	-18.05608	-63.42788	601	59",
	"08	La Bélgica	-17.55	-63.21667	353	59",
	"08	Limoncito	-18.02782	-63.40307	594	59",
	"08	Los Negros	-17.73333	-63.43333	420	59",
	"08	Mairana	-18.1199	-63.96058	1471	59",
	"08	Mineros	-17.11918	-63.23226	254	59",
	"08	Montero	-17.33874	-63.25093	300	59",
	"08	Okinawa Número Uno	-17.23333	-62.81667	260	59",
	"08	Okinawa Uno	-17.38591	-62.8967	283	59",
	"08	Pailón	-17.66395	-62.71804	250	59",
	"08	Paurito	-17.88093	-62.9414	315	59",
	"08	Portachuelo	-17.35374	-63.39571	298	59",
	"08	Puearto Pailas	-17.663	-62.81227	300	59",
	"08	Puerto Pailas	-17.66783	-62.79025	256	59",
	"08	Puerto Quijarro	-17.78333	-57.76667	92	59",
	"08	Puerto Suárez	-18.96722	-57.80127	218	59",
	"08	Roboré	-18.33473	-59.76142	258	59",
	"08	Samaipata	-18.17754	-63.87563	1694	59",
	"08	San Carlos	-17.40447	-63.732	310	59",
	"08	San Ignacio de Velasco	-16.37767	-60.96472	582	59",
	"08	San Juan del Surutú	-17.48333	-63.7	320	59",
	"08	San Julian	-17.78333	-62.86667	332	59",
	"08	San Julian	-17.80623	-62.89536	339	59",
	"08	San Matías	-16.3597	-58.40039	175	59",
	"08	San Pedro	-18.28691	-59.81742	288	59",
	"08	Santa Cruz de la Sierra	-17.78629	-63.18117	433	59",
	"08	Santa Fe	-17.90818	-63.03955	377	59",
	"08	Santa Rita	-17.97974	-63.37084	566	59",
	"08	Santa Rosa del Sara	-17.10805	-63.59967	288	59",
	"08	Urubichá	-15.39286	-62.94661	295	59",
	"08	Vallegrande	-18.48887	-64.10827	1985	59",
	"08	Villa Yapacaní	-17.4	-63.83333	297	59",
	"08	Warnes	-17.5163	-63.16778	340	59",
	"09	Bermejo	-22.73206	-64.33724	416	59",
	"09	Entre Ríos	-21.52661	-64.17299	1232	59",
	"09	Tarija	-21.53549	-64.72956	1870	59",
	"09	Villamontes	-21.26235	-63.46903	388	59",
	"09	Yacuiba	-22.01643	-63.67753	629	59",
];
