const CITIES = [
	"02	Al Bahah	20.01288	41.46767	2176	335",
	"02	Al Mindak	20.1588	41.28337	2006	335",
	"05	Al-`Ula	26.60853	37.92316	692	335",
	"05	Badr Ḩunayn	23.78292	38.79047	116	335",
	"05	Medina	24.46861	39.61417	603	335",
	"05	Sulţānah	24.49258	39.58572	597	335",
	"05	Yanbu	24.08954	38.0618	6	335",
	"06	Abqaiq	25.93402	49.6688	103	335",
	"06	Al Awjām	26.56324	49.94331	14	335",
	"06	Al Baţţālīyah	25.43333	49.63333	143	335",
	"06	Al Hufūf	25.36467	49.58764	159	335",
	"06	Al Jafr	25.37736	49.72154	135	335",
	"06	Al Ju‘aymah	26.75007	49.90469	9	335",
	"06	Al Jubayl	25.4	49.65	140	335",
	"06	Al Jubayl	27.0174	49.62251	5	335",
	"06	Al Khafjī	28.43905	48.49132	3	335",
	"06	Al Markaz	25.4	49.73333	128	335",
	"06	Al Mubarraz	25.40768	49.59028	148	335",
	"06	Al Munayzilah	25.38333	49.66667	148	335",
	"06	Al Muţayrifī	25.47878	49.55824	153	335",
	"06	Al Qārah	25.41667	49.66667	137	335",
	"06	Al Qaţīf	26.56542	50.0089	3	335",
	"06	Al Qurayn	25.48333	49.6	140	335",
	"06	As Saffānīyah	27.97083	48.73	14	335",
	"06	Aţ Ţaraf	25.36232	49.72757	133	335",
	"06	At Tūbī	26.55778	49.99167	11	335",
	"06	Dammam	26.43442	50.10326	10	335",
	"06	Dhahran	26.28864	50.11396	44	335",
	"06	Hafar Al-Batin	28.43279	45.97077	310	335",
	"06	Julayjilah	25.5	49.6	139	335",
	"06	Khobar	26.27944	50.20833	8	335",
	"06	Mulayjah	27.27103	48.42419	72	335",
	"06	Qaisumah	28.31117	46.12729	363	335",
	"06	Raḩīmah	26.70791	50.06194	7	335",
	"06	Şafwá	26.6497	49.95522	18	335",
	"06	Sayhāt	26.48345	50.04849	3	335",
	"06	Shaybah	22.59246	54.09599	153	335",
	"06	Tārūt	26.5733	50.04028	4	335",
	"06	Umm as Sāhik	26.65361	49.91639	9	335",
	"08	Adh Dhibiyah	26.027	43.157	745	335",
	"08	Al Bukayrīyah	26.13915	43.65782	671	335",
	"08	Al Fuwayliq	26.4436	43.25164	766	335",
	"08	Al Mithnab	25.86012	44.22228	632	335",
	"08	Alrmtheiah	24.74299	42.95528	1027	335",
	"08	Ar Rass	25.86944	43.4973	691	335",
	"08	Buraydah	26.32599	43.97497	606	335",
	"08	Tanūmah	27.1	44.13333	587	335",
	"08	Unaizah	26.08793	43.96368	654	335",
	"08	Wed Alnkil	25.4267	42.8343	812	335",
	"10	Ad Dawādimī	24.50772	44.39237	975	335",
	"10	Ad Dilam	23.99104	47.16181	453	335",
	"10	Afif	23.9065	42.91724	1045	335",
	"10	Ain AlBaraha	24.75806	43.77389	909	335",
	"10	Al Arţāwīyah	26.50387	45.34813	609	335",
	"10	Al Kharj	24.15541	47.33457	438	335",
	"10	Al Majma‘ah	25.91097	45.35665	712	335",
	"10	As Sulayyil	20.46067	45.57792	606	335",
	"10	Az Zulfī	26.29945	44.81542	620	335",
	"10	Marāt	25.07064	45.45775	711	335",
	"10	Riyadh	24.68773	46.72185	612	335",
	"10	Sājir	25.18251	44.59964	732	335",
	"10	shokhaibٍ	24.49023	46.26871	621	335",
	"10	Tumayr	25.70347	45.86835	656	335",
	"11	Abha	18.21639	42.50528	2228	335",
	"11	Al Majāridah	19.12361	41.91111	429	335",
	"11	An Nimas	19.14547	42.12009	2385	335",
	"11	Bariq	18.92966	41.92953	395	335",
	"11	Khamis Mushait	18.3	42.73333	1998	335",
	"11	Qal‘at Bīshah	20.00054	42.6052	1168	335",
	"11	Sabt Alalayah	19.5773	41.96357	1989	335",
	"11	Tabālah	19.95	42.4	1233	335",
	"13	Ha'il	27.52188	41.69073	1002	335",
	"14	Al Hadā	21.35903	40.2803	1961	335",
	"14	Al Jumūm	21.61951	39.69659	208	335",
	"14	Al Muwayh	22.43333	41.75829	975	335",
	"14	Ash Shafā	21.07268	40.31842	2231	335",
	"14	Jeddah	21.49012	39.18624	7	335",
	"14	Mecca	21.42664	39.82563	333	335",
	"14	Rābigh	22.79856	39.03493	7	335",
	"14	Ta’if	21.27028	40.41583	1672	335",
	"14	Turabah	21.21406	41.6331	1164	335",
	"15	Arar	30.97531	41.03808	555	335",
	"15	Turaif	31.67252	38.66374	827	335",
	"16	Najrān	17.49326	44.12766	1310	335",
	"17	Abū ‘Arīsh	16.96887	42.83251	69	335",
	"17	Ad Darb	17.72285	42.25261	73	335",
	"17	Al Jarādīyah	16.57946	42.9124	49	335",
	"17	Farasān	16.70222	42.11833	22	335",
	"17	Jizan	16.88917	42.55111	19	335",
	"17	Mislīyah	17.45988	42.5572	127	335",
	"17	Mizhirah	16.82611	42.73333	21	335",
	"17	Şabyā	17.1495	42.62537	36	335",
	"17	Şāmitah	16.59601	42.94435	62	335",
	"19	Al Wajh	26.24551	36.45249	20	335",
	"19	Duba	27.35134	35.69014	13	335",
	"19	Tabuk	28.3998	36.57151	768	335",
	"19	Umluj	25.02126	37.2685	4	335",
	"20	Qurayyat	31.33176	37.34282	498	335",
	"20	Sakakah	29.96974	40.20641	555	335",
	"20	Şuwayr	30.11713	40.38925	592	335",
	"20	Ţubarjal	30.49987	38.21603	546	335",
];