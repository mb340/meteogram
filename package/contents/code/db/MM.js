const CITIES = [
	"01	Sittwe	20.14624	92.89835	5	242",
	"02	Falam	22.91335	93.67779	1579	242",
	"02	Hakha	22.64452	93.61076	1799	242",
	"03	Bogale	16.29415	95.39742	11	242",
	"03	Hinthada	17.64944	95.45705	15	242",
	"03	Kyaiklat	16.44502	95.72373	10	242",
	"03	Maubin	16.73148	95.65441	11	242",
	"03	Mawlamyinegyunn	16.3772	95.26488	8	242",
	"03	Myanaung	18.28651	95.32014	26	242",
	"03	Nyaungdon	17.04459	95.63957	11	242",
	"03	Pathein	16.77919	94.73212	8	242",
	"03	Pyapon	16.28543	95.67882	8	242",
	"03	Wakema	16.60333	95.18278	11	242",
	"04	Bhamo	24.25256	97.23357	115	242",
	"04	Myitkyina	25.38327	97.39637	147	242",
	"05	Dellok	16.04072	97.91773	18	242",
	"05	Hpa-An	16.88953	97.63482	18	242",
	"05	Klonhtoug	15.95411	98.4325	31	242",
	"05	Kyain Seikgyi Township	15.82288	98.25257	48	242",
	"05	Mikenaungea	15.95846	98.42721	39	242",
	"05	Myawadi	16.68911	98.50893	206	242",
	"05	Pulei	16.06243	97.8828	19	242",
	"05	Tagondaing	16.0675	97.90694	21	242",
	"05	Tamoowoug	16.03447	97.91458	18	242",
	"06	Loikaw	19.67798	97.20975	893	242",
	"08	Kyaukse	21.6056	96.13508	86	242",
	"08	Mandalay	21.97473	96.08359	83	242",
	"08	Meiktila	20.87776	95.85844	244	242",
	"08	Mogok	22.91766	96.50982	1162	242",
	"08	Myingyan	21.46002	95.3884	76	242",
	"08	Nyaungshwe	20.66084	96.93405	894	242",
	"08	Pyin Oo Lwin	22.03501	96.45683	1088	242",
	"08	Yamethin	20.43189	96.13875	203	242",
	"10	Mawlaik	23.64254	94.40478	129	242",
	"10	Monywa	22.10856	95.13583	81	242",
	"10	Sagaing	21.8787	95.97965	75	242",
	"10	Shwebo	22.56925	95.69818	111	242",
	"11	Indein	20.46102	96.8415	896	242",
	"11	Kēng Tung	21.63093	99.92676	690	242",
	"11	Lashio	22.9359	97.7498	845	242",
	"11	Tachilek	20.4475	99.88083	402	242",
	"11	Taunggyi	20.78919	97.03776	1396	242",
	"12	Dawei	14.0823	98.19151	17	242",
	"12	Kawthoung	9.98238	98.55034	34	242",
	"12	Myeik	12.43954	98.60028	15	242",
	"13	Kyaikkami	16.07686	97.56388	21	242",
	"13	Kyaikto	17.30858	97.01124	23	242",
	"13	Martaban	16.52834	97.6157	27	242",
	"13	Mawlamyine	16.49051	97.62825	52	242",
	"13	Mudon	16.25624	97.7246	22	242",
	"13	Thaton	16.91867	97.37001	24	242",
	"15	Chauk	20.89921	94.81784	59	242",
	"15	Magway	20.14956	94.93246	60	242",
	"15	Minbu	20.18059	94.87595	49	242",
	"15	Myaydo	19.36838	95.21512	48	242",
	"15	Pakokku	21.33489	95.08438	70	242",
	"15	Taungdwingyi	20.0065	95.54531	143	242",
	"15	Thayetmyo	19.32076	95.18272	47	242",
	"15	Yenangyaung	20.46504	94.8712	56	242",
	"16	Bago	17.33521	96.48135	18	242",
	"16	Letpandan	17.78664	95.75076	23	242",
	"16	Nyaunglebin	17.95363	96.72247	19	242",
	"16	Paungde	18.49167	95.50591	35	242",
	"16	Pyay	18.82464	95.22216	32	242",
	"16	Pyu	18.4813	96.43742	55	242",
	"16	Taungoo	18.94291	96.43408	56	242",
	"16	Thanatpin	17.29136	96.57523	13	242",
	"16	Tharyarwady	17.65399	95.78813	17	242",
	"17	Kanbe	16.70728	96.00168	12	242",
	"17	Kayan	16.90802	96.56037	13	242",
	"17	Syriam	16.76887	96.24503	24	242",
	"17	Thongwa	16.75998	96.52498	10	242",
	"17	Twante	16.71047	95.92866	14	242",
	"17	Yangon	16.80528	96.15611	30	242",
	"18	Nay Pyi Taw	19.745	96.12972	122	242",
	"18	Pyinmana	19.7381	96.20742	101	242",
];
