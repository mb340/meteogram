const CITIES = [
	"00	Bečići	42.28389	18.86917	47	235",
	"00	Lipci	42.49722	18.65806	5	235",
	"01	Andrijevica	42.73389	19.79194	783	235",
	"02	Bar	42.0937	19.09841	5	235",
	"02	Dobra Voda	42.04889	19.14389	213	235",
	"02	Stari Bar	42.097	19.136	184	235",
	"02	Šušanj	42.11556	19.08833	45	235",
	"02	Sutomore	42.14278	19.04667	30	235",
	"03	Berane	42.8425	19.87333	676	235",
	"04	Barice	43.0875	19.485	1405	235",
	"04	Bijelo Polje	43.03834	19.74758	623	235",
	"05	Budva	42.28639	18.84	7	235",
	"05	Petrovac na Moru	42.20556	18.9425	9	235",
	"06	Cetinje	42.39063	18.91417	686	235",
	"06	Njeguši	42.43388	18.81018	906	235",
	"07	Ćurilac	42.53472	19.1175	50	235",
	"07	Danilovgrad	42.55384	19.14608	49	235",
	"07	Grbe	42.5	19.19583	48	235",
	"07	Spuž	42.515	19.195	61	235",
	"08	Baošići	42.4425	18.63	7	235",
	"08	Bijela	42.45333	18.65556	6	235",
	"08	Ðenovići	42.43694	18.60222	14	235",
	"08	Herceg Novi	42.45306	18.5375	87	235",
	"08	Igalo	42.46007	18.50647	30	235",
	"09	Kolašin	42.82229	19.51653	936	235",
	"10	Dobrota	42.45417	18.76833	69	235",
	"10	Kotor	42.42067	18.76825	5	235",
	"10	Muo	42.43167	18.7575	10	235",
	"10	Perast	42.48694	18.69917	29	235",
	"10	Prčanj	42.4575	18.74222	8	235",
	"10	Risan	42.515	18.69556	12	235",
	"10	Škaljari	42.41861	18.76639	17	235",
	"11	Mojkovac	42.96044	19.5833	826	235",
	"12	Dučice	42.71528	19.12333	854	235",
	"12	Kuta	42.74111	19.11917	855	235",
	"12	Miločani	42.82917	18.90444	625	235",
	"12	Nikšić	42.7731	18.94446	630	235",
	"12	Zagrad	42.75	19.09111	937	235",
	"13	Plav	42.59694	19.94556	948	235",
	"13	Prnjavor	42.59806	19.95056	976	235",
	"14	Pljevlja	43.3567	19.35843	772	235",
	"14	Šula	43.38472	19.07306	1105	235",
	"15	Plužine	43.15278	18.83944	693	235",
	"16	Bijelo Polje	42.30306	19.19806	9	235",
	"16	Botun	42.385	19.2	20	235",
	"16	Dinoša	42.41861	19.33889	88	235",
	"16	Donji Kokoti	42.40111	19.19722	26	235",
	"16	Golubovci	42.335	19.23111	12	235",
	"16	Goričani	42.33222	19.21194	11	235",
	"16	Mataguži	42.32361	19.27278	16	235",
	"16	Mojanovići	42.34167	19.22139	11	235",
	"16	Podgorica	42.44111	19.26361	49	235",
	"16	Stijena	42.51944	19.25806	489	235",
	"17	Rožaje	42.83299	20.16652	1081	235",
	"18	Šavnik	42.95639	19.09667	843	235",
	"19	Donja Lastva	42.44306	18.68861	5	235",
	"19	Mrčevac	42.42	18.71806	21	235",
	"19	Tivat	42.43623	18.69361	2	235",
	"20	Ulcinj	41.92936	19.22436	8	235",
	"21	Žabljak	43.15423	19.12325	1448	235",
	"22	Gusinje	42.56194	19.83389	924	235",
	"23	Petnjica	42.90889	19.96444	724	235",
	"24	Tuzi	42.36556	19.33139	48	235",
	"24	Vranj	42.32583	19.29778	20	235",
];