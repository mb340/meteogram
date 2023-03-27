const CITIES = [
	"01	Bakau	13.47806	-16.68194	22	170",
	"01	Banjul	13.45274	-16.57803	5	170",
	"01	Serekunda	13.43833	-16.67806	15	170",
	"02	Bajana	13.31667	-15.88333	33	170",
	"02	Baro Kunda	13.48333	-15.26667	16	170",
	"02	Buiba Mandinka	13.43333	-15.45	14	170",
	"02	Bureng	13.41667	-15.28333	6	170",
	"02	Diganteh	13.36667	-15.43333	46	170",
	"02	Dongoro Ba	13.38333	-15.28333	20	170",
	"02	Dumbutu	13.35	-15.83333	29	170",
	"02	Jali	13.35	-15.96667	31	170",
	"02	Janneh Kunda	13.38028	-16.13833	12	170",
	"02	Jassong	13.4	-15.31667	39	170",
	"02	Jenoi	13.48333	-15.56667	8	170",
	"02	Jifarong	13.3	-15.86667	28	170",
	"02	Jiffin	13.41667	-15.58333	33	170",
	"02	Jiroff	13.41667	-15.7	25	170",
	"02	Kaiaf	13.4	-15.61667	29	170",
	"02	Karantaba	13.43333	-15.51667	37	170",
	"02	Keneba	13.32889	-16.015	22	170",
	"02	Kuli Kunda	13.33333	-15.91667	31	170",
	"02	Madina	13.5	-15.25	4	170",
	"02	Mansa Konko	13.44325	-15.5357	19	170",
	"02	Massembe	13.41667	-15.63333	16	170",
	"02	Nioro	13.35	-15.75	38	170",
	"02	Sankandi	13.3	-15.83333	21	170",
	"02	Sankwia	13.46667	-15.51667	4	170",
	"02	Sibito	13.38333	-15.73333	35	170",
	"02	Si Kunda	13.43333	-15.56667	28	170",
	"02	Soma	13.43333	-15.53333	21	170",
	"02	Sukuta	13.53333	-15.2	12	170",
	"02	Sutukung	13.46667	-15.26667	11	170",
	"02	Tankular	13.41778	-16.03694	3	170",
	"02	Toniataba	13.43333	-15.58333	4	170",
	"02	Wellingara Ba	13.41667	-15.4	28	170",
	"02	Wurokang	13.38333	-15.81667	26	170",
	"03	Bani	13.55	-14.73333	8	170",
	"03	Bansang	13.43333	-14.65	9	170",
	"03	Bati Ndar	13.7	-15.2	18	170",
	"03	Brikama Nding	13.53333	-14.93333	16	170",
	"03	Buniadu	13.55	-15.33333	24	170",
	"03	Cha Kunda	13.38333	-14.53333	23	170",
	"03	Dankunku	13.56667	-15.31667	26	170",
	"03	Denton	13.5	-14.93333	18	170",
	"03	Dingirie	13.76667	-14.91667	46	170",
	"03	Dobbo	13.46667	-14.63333	11	170",
	"03	Fass	13.8	-15.06667	21	170",
	"03	Galleh Manda	13.43333	-14.78333	46	170",
	"03	Jakaba	13.65	-14.88333	16	170",
	"03	Jakhaly	13.55	-14.96667	11	170",
	"03	Janjanbureh	13.54039	-14.76374	7	170",
	"03	Jarreng	13.61667	-15.18333	15	170",
	"03	Karantaba	13.66667	-15.03333	11	170",
	"03	Kass Wollof	13.78333	-14.93333	44	170",
	"03	Katamina	13.55	-15.28333	17	170",
	"03	Kuntaur	13.67085	-14.88977	5	170",
	"03	Kunting	13.53333	-14.66667	14	170",
	"03	Madina	13.7	-14.88333	7	170",
	"03	Madina Tunjang	13.43333	-14.75	49	170",
	"03	Mara Magai	13.51667	-14.91667	16	170",
	"03	Pateh Sam	13.61667	-15.06667	22	170",
	"03	Sambang	13.53333	-15.33333	1	170",
	"03	Sami	13.58333	-15.2	19	170",
	"03	Saruja	13.55	-14.91667	11	170",
	"03	Sukuta	13.61667	-14.91667	13	170",
	"03	Sulolor	13.45	-14.66667	9	170",
	"03	Tuba	13.46667	-14.68333	12	170",
	"03	Tuba Koto	13.63333	-14.9	8	170",
	"03	Wassu	13.69094	-14.87884	11	170",
	"04	Badari	13.33333	-14.1	26	170",
	"04	Bakadagy	13.3	-14.38333	18	170",
	"04	Banto Nding	13.46667	-14.08333	26	170",
	"04	Basse Santa Su	13.30995	-14.21373	15	170",
	"04	Brifu	13.5	-13.93333	27	170",
	"04	Daba Kunda	13.31667	-14.3	20	170",
	"04	Demba Kunda	13.25	-14.26667	39	170",
	"04	Diabugu	13.38333	-14.4	17	170",
	"04	Diabugu Basilla	13.33333	-13.95	19	170",
	"04	Giroba Kunda	13.3	-14.2	19	170",
	"04	Gunjur Kuta	13.53333	-14.11667	48	170",
	"04	Jababa	13.36667	-14.36667	8	170",
	"04	Kerewan	13.36667	-14.21667	21	170",
	"04	Koina	13.48333	-13.86667	17	170",
	"04	Kumbija	13.26667	-14.18333	38	170",
	"04	Nyamanari	13.33333	-13.86667	48	170",
	"04	Perai	13.38333	-14.03333	14	170",
	"04	Sabi	13.23333	-14.2	39	170",
	"04	Sanunding	13.28333	-14.11667	20	170",
	"04	Sudowol	13.36667	-13.96667	23	170",
	"04	Sun Kunda	13.38333	-13.85	29	170",
	"04	Sutukoba	13.5	-14.01667	29	170",
	"04	Tuba-Wuli	13.43333	-14.25	28	170",
	"04	Walliba Kunda	13.36667	-14.01667	23	170",
	"05	Abuko	13.40417	-16.65583	15	170",
	"05	Brikama	13.27136	-16.64944	24	170",
	"05	Gunjur	13.20194	-16.73389	25	170",
	"05	Jarrol	13.24412	-15.84546	22	170",
	"05	Mayork	13.23333	-15.96667	27	170",
	"05	Nema Kunku	13.25	-15.88333	18	170",
	"05	Sintet	13.23333	-15.81667	16	170",
	"05	Somita	13.20583	-16.30556	27	170",
	"05	Sukuta	13.41033	-16.70815	27	170",
	"07	Bambali	13.48333	-15.33333	17	170",
	"07	Bantang Killing	13.58333	-15.7	38	170",
	"07	Barra	13.48278	-16.54556	1	170",
	"07	Chilla	13.55	-16.28333	36	170",
	"07	Daru Rilwan	13.55	-15.98333	37	170",
	"07	Dobo	13.55	-15.96667	39	170",
	"07	Essau	13.48389	-16.53472	12	170",
	"07	Farafenni	13.56667	-15.6	15	170",
	"07	Gunjur	13.52278	-16.02778	15	170",
	"07	India	13.56667	-15.75	11	170",
	"07	Jeriko	13.58333	-15.66667	41	170",
	"07	Katchang	13.5	-15.75	20	170",
	"07	Kerewan	13.4898	-16.08879	16	170",
	"07	Kinteh Kunda	13.50722	-16.06722	14	170",
	"07	Kumbijae	13.53333	-15.43333	10	170",
	"07	Lamin	13.35222	-16.43389	15	170",
	"07	Medina Kanuma	13.49278	-16.52333	6	170",
	"07	No Kunda	13.56667	-15.83333	14	170",
	"07	Saba	13.51639	-16.04917	15	170",
	"07	Sara Kunda	13.53333	-15.41667	20	170",
	"07	Tambana	13.50528	-16.17444	25	170",
	"07	Yallal	13.55	-15.7	32	170",
];
