const CITIES = [
	"10	Waitangi	-43.95353	-176.55973	18	281",
	"E7	Albany	-36.71667	174.7	53	280",
	"E7	Auckland	-36.84853	174.76349	43	280",
	"E7	Avondale	-36.88333	174.7	41	280",
	"E7	Balmoral	-36.8882	174.74019	49	280",
	"E7	Beach Haven	-36.7882	174.68019	4	280",
	"E7	Beachlands	-36.88333	175	26	280",
	"E7	Belmont	-36.8075	174.78639	19	280",
	"E7	Birkdale	-36.79718	174.70459	54	280",
	"E7	Birkenhead	-36.8082	174.72019	76	280",
	"E7	Blockhouse Bay	-36.9182	174.70019	47	280",
	"E7	Bombay	-37.16667	174.98333	102	280",
	"E7	Botany Downs	-36.90596	174.91788	46	280",
	"E7	Browns Bay	-36.71926	174.73666	31	280",
	"E7	Bucklands Beach	-36.8582	174.90019	6	280",
	"E7	Campbells Bay	-36.74645	174.75978	18	280",
	"E7	Chatswood	-36.81841	174.70984	75	280",
	"E7	Clevedon	-37	175.05	10	280",
	"E7	Cockle Bay	-36.8982	174.94019	39	280",
	"E7	Dairy Flat	-36.66667	174.65	63	280",
	"E7	Drury	-37.1	174.95	14	280",
	"E7	Eastern Beach	-36.8682	174.90019	2	280",
	"E7	Eden Terrace	-36.86579	174.75725	81	280",
	"E7	Ellerslie	-36.8982	174.81019	35	280",
	"E7	Epsom	-36.88745	174.77059	79	280",
	"E7	Farm Cove	-36.8882	174.88019	-9999	280",
	"E7	Favona	-36.93333	174.8	24	280",
	"E7	Forrest Hill	-36.76447	174.74773	43	280",
	"E7	Freemans Bay	-36.8482	174.74019	39	280",
	"E7	Glendene	-36.8882	174.64019	56	280",
	"E7	Glendowie	-36.8582	174.87019	32	280",
	"E7	Glen Innes	-36.8682	174.86019	37	280",
	"E7	Grafton	-36.86029	174.76566	65	280",
	"E7	Green Bay	-36.93096	174.67489	42	280",
	"E7	Greenhithe	-36.77081	174.68651	47	280",
	"E7	Grey Lynn	-36.86489	174.73695	53	280",
	"E7	Hauraki	-36.79961	174.778	42	280",
	"E7	Helensville	-36.67819	174.45019	15	280",
	"E7	Henderson	-36.8782	174.61019	39	280",
	"E7	Highland Park	-36.8982	174.90019	23	280",
	"E7	Hillcrest	-36.7882	174.73019	50	280",
	"E7	Hillsborough	-36.9182	174.75019	75	280",
	"E7	Homai	-37.01667	174.88333	37	280",
	"E7	Howick	-36.89359	174.93174	52	280",
	"E7	Huia	-36.99834	174.56665	9	280",
	"E7	Kaukapakapa	-36.61667	174.5	24	280",
	"E7	Kelston	-36.8982	174.66019	23	280",
	"E7	Kingsland	-36.8682	174.73019	17	280",
	"E7	Kohimarama	-36.8582	174.84019	35	280",
	"E7	Konini	-36.9282	174.64019	78	280",
	"E7	Kumeu	-36.76667	174.56667	69	280",
	"E7	Leigh	-36.28333	174.81667	21	280",
	"E7	Lincoln	-36.8582	174.62019	11	280",
	"E7	Lynfield	-36.9282	174.72019	55	280",
	"E7	Mangere	-36.96807	174.79875	15	280",
	"E7	Mangere East	-36.96587	174.82389	21	280",
	"E7	Manukau City	-36.99282	174.87986	43	280",
	"E7	Manurewa	-37.0182	174.88019	38	280",
	"E7	Manurewa East	-37.0182	174.91019	54	280",
	"E7	Massey	-36.8382	174.61019	41	280",
	"E7	Massey East	-36.8282	174.62019	46	280",
	"E7	McLaren Park	-36.8882	174.61019	63	280",
	"E7	Meadowbank	-36.8682	174.82019	34	280",
	"E7	Mellons Bay	-36.88295	174.9299	13	280",
	"E7	Milford	-36.77158	174.76585	18	280",
	"E7	Mission Bay	-36.85472	174.83167	37	280",
	"E7	Morningside	-36.8682	174.73019	17	280",
	"E7	Muriwai Beach	-36.83659	174.43298	162	280",
	"E7	Murrays Bay	-36.72819	174.75019	40	280",
	"E7	Narrow Neck	-36.81542	174.79933	7	280",
	"E7	New Lynn	-36.90694	174.68704	21	280",
	"E7	Newmarket	-36.86977	174.77566	64	280",
	"E7	Newton	-36.85843	174.75005	14	280",
	"E7	New Windsor	-36.8982	174.70019	47	280",
	"E7	North Shore	-36.8	174.75	30	280",
	"E7	Oneroa	-36.77819	175.01019	-9999	280",
	"E7	Opaheke	-37.08333	174.96667	23	280",
	"E7	Oranga	-36.9082	174.79019	87	280",
	"E7	Oratia	-36.91667	174.61667	53	280",
	"E7	Orewa	-36.581	174.679	57	280",
	"E7	Ostend	-36.7982	175.04019	17	280",
	"E7	Otahuhu	-36.9382	174.84019	17	280",
	"E7	Otara	-36.9482	174.87019	10	280",
	"E7	Owairaka	-36.8882	174.71019	48	280",
	"E7	Pakuranga	-36.88333	174.91667	36	280",
	"E7	Pakuranga Heights	-36.9082	174.88019	33	280",
	"E7	Panmure	-36.88333	174.86667	15	280",
	"E7	Papakura	-37.06573	174.94393	27	280",
	"E7	Papatoetoe	-36.9682	174.84019	19	280",
	"E7	Parakai	-36.65	174.43333	4	280",
	"E7	Paremoremo	-36.76667	174.66667	12	280",
	"E7	Parnell	-36.86667	174.78333	43	280",
	"E7	Penrose	-36.91667	174.81667	30	280",
	"E7	Point Chevalier	-36.86328	174.70493	28	280",
	"E7	Ponsonby	-36.85	174.73333	15	280",
	"E7	Pukekohe East	-37.2	174.95	115	280",
	"E7	Ramarama	-37.15	174.95	23	280",
	"E7	Red Hill	-37.0582	174.97019	32	280",
	"E7	Remuera	-36.88041	174.79819	88	280",
	"E7	Riverhead	-36.75	174.6	20	280",
	"E7	Rosebank	-36.87495	174.66991	19	280",
	"E7	Rothesay Bay	-36.72602	174.74064	46	280",
	"E7	Royal Oak	-36.9082	174.77019	64	280",
	"E7	Saint Johns	-36.8682	174.84019	40	280",
	"E7	Saint Marys Bay	-36.8382	174.74019	17	280",
	"E7	Sandringham	-36.8882	174.73019	40	280",
	"E7	Shelly Park	-36.90749	174.9459	51	280",
	"E7	Silverdale	-36.6187	174.67764	17	280",
	"E7	Snells Beach	-36.40819	174.72019	74	280",
	"E7	Sunnyhills	-36.8982	174.88019	18	280",
	"E7	Sunnyvale	-36.8882	174.63019	24	280",
	"E7	Takanini	-37.0482	174.90019	18	280",
	"E7	Takapuna	-36.79167	174.77583	22	280",
	"E7	Tamaki	-36.8882	174.86019	28	280",
	"E7	Te Atatu Peninsula	-36.84103	174.65223	25	280",
	"E7	Te Atatu South	-36.86472	174.64768	44	280",
	"E7	Te Papapa	-36.9182	174.80019	19	280",
	"E7	Three Kings	-36.8982	174.75019	67	280",
	"E7	Titirangi	-36.93754	174.65584	162	280",
	"E7	Waiatarua	-36.93333	174.58333	272	280",
	"E7	Waima	-36.9382	174.63019	179	280",
	"E7	Waitakere	-36.85126	174.54477	83	280",
	"E7	Waiuku	-37.24806	174.73489	13	280",
	"E7	Warkworth	-36.4	174.66667	23	280",
	"E7	Waterview	-36.8782	174.69019	1	280",
	"E7	Wattle Downs	-37.0382	174.89019	20	280",
	"E7	Wellsford	-36.28333	174.51667	56	280",
	"E7	Western Heights	-36.8782	174.61019	39	280",
	"E7	West Harbour	-36.8182	174.61019	48	280",
	"E7	Westmere	-36.85538	174.71991	27	280",
	"E7	Whitford	-36.93333	174.96667	5	280",
	"E7	Wiri	-36.9982	174.86019	23	280",
	"E7	Woodlands Park	-36.9482	174.62019	193	280",
	"E8	Athenree	-37.46667	175.91667	56	280",
	"E8	Awakeri	-38	176.9	14	280",
	"E8	Bethlehem	-37.69496	176.10861	36	280",
	"E8	Edgecumbe	-37.98333	176.83333	9	280",
	"E8	Greerton	-37.72541	176.13346	43	280",
	"E8	Hamurana	-38.03333	176.26667	289	280",
	"E8	Kaharoa	-37.99513	176.23467	416	280",
	"E8	Katikati	-37.55	175.91667	9	280",
	"E8	Kawerau	-38.1	176.7	46	280",
	"E8	Maketu	-37.76667	176.45	12	280",
	"E8	Mamaku	-38.1	176.08333	577	280",
	"E8	Matata	-37.88333	176.75	-9999	280",
	"E8	Murupara	-38.46667	176.7	201	280",
	"E8	Ngongotaha	-38.08333	176.2	292	280",
	"E8	Ohinemutu	-38.15	176.28333	313	280",
	"E8	Omokoroa	-37.64849	176.03497	26	280",
	"E8	Opotiki	-38.00915	177.28706	7	280",
	"E8	Oropi	-37.83948	176.16105	321	280",
	"E8	Otumoetai	-37.67156	176.13865	53	280",
	"E8	Paengaroa	-37.81667	176.41667	27	280",
	"E8	Reporoa	-38.43594	176.34117	300	280",
	"E8	Rotorua	-38.13874	176.24516	287	280",
	"E8	Taneatua	-38.06667	177.01667	22	280",
	"E8	Tauranga	-37.68611	176.16667	18	280",
	"E8	Waihi Beach	-37.4	175.93333	17	280",
	"E8	Waimana	-38.15	177.08333	47	280",
	"E8	Whakatane	-37.95855	176.98545	11	280",
	"E9	Aidanfield	-43.56666	172.5686	16	280",
	"E9	Akaroa	-43.80384	172.96817	8	280",
	"E9	Amberley	-43.15589	172.72975	46	280",
	"E9	Aranui	-43.50833	172.70013	5	280",
	"E9	Arthur’s Pass	-42.95	171.56667	745	280",
	"E9	Ashburton	-43.89834	171.73011	106	280",
	"E9	Avonhead	-43.50833	172.55013	28	280",
	"E9	Avonside	-43.51833	172.66013	6	280",
	"E9	Beckenham	-43.56497	172.64105	13	280",
	"E9	Belfast	-43.45	172.63333	10	280",
	"E9	Bexley	-43.50833	172.71013	3	280",
	"E9	Bishopdale	-43.47833	172.58013	21	280",
	"E9	Bryndwr	-43.49833	172.59013	17	280",
	"E9	Burnham	-43.61667	172.31667	62	280",
	"E9	Burnside	-43.49833	172.56013	28	280",
	"E9	Cashmere	-43.5678	172.628	15	280",
	"E9	Christchurch	-43.53333	172.63333	14	280",
	"E9	Clifton	-43.56435	172.7492	22	280",
	"E9	Dallington	-43.50833	172.67013	4	280",
	"E9	Darfield	-43.48333	172.11667	204	280",
	"E9	Ealing	-44.05	171.41667	112	280",
	"E9	Fairlie	-44.1	170.83333	305	280",
	"E9	Fendalton	-43.51667	172.6	13	280",
	"E9	Geraldine	-44.09061	171.24458	119	280",
	"E9	Governors Bay	-43.62266	172.64663	87	280",
	"E9	Hakataramea	-44.73333	170.48333	199	280",
	"E9	Halswell	-43.58333	172.56667	18	280",
	"E9	Hanmer Springs	-42.51667	172.81667	391	280",
	"E9	Hillsborough	-43.56257	172.67371	4	280",
	"E9	Hoon Hay	-43.56444	172.60766	15	280",
	"E9	Ilam	-43.51833	172.57013	20	280",
	"E9	Kaiapoi	-43.37832	172.64013	4	280",
	"E9	Kaikoura	-42.41667	173.68333	38	280",
	"E9	Kennedys Bush	-43.60324	172.5816	91	280",
	"E9	Kirwee	-43.5	172.21667	159	280",
	"E9	Ladbrooks	-43.61667	172.53333	16	280",
	"E9	Leeston	-43.76667	172.3	18	280",
	"E9	Leithfield	-43.2	172.73333	23	280",
	"E9	Lincoln	-43.65	172.48333	8	280",
	"E9	Loburn	-43.25	172.53333	101	280",
	"E9	Lyttelton	-43.60314	172.71765	6	280",
	"E9	Mairehau	-43.49833	172.64013	7	280",
	"E9	Methven	-43.63333	171.65	319	280",
	"E9	New Brighton	-43.51667	172.73333	6	280",
	"E9	Opawa	-43.55499	172.66139	10	280",
	"E9	Oxford	-43.3	172.18333	244	280",
	"E9	Papanui	-43.5	172.61667	10	280",
	"E9	Parklands	-43.47833	172.69013	5	280",
	"E9	Pegasus	-43.30832	172.69013	8	280",
	"E9	Pleasant Point	-44.26667	171.13333	89	280",
	"E9	Prebbleton	-43.58333	172.51667	21	280",
	"E9	Rakaia	-43.75	172.01667	118	280",
	"E9	Rangiora	-43.30437	172.58356	36	280",
	"E9	Redcliffs	-43.56152	172.73654	4	280",
	"E9	Redwood	-43.46833	172.61013	15	280",
	"E9	Riccarton	-43.52833	172.59013	14	280",
	"E9	Richmond	-43.50833	172.65013	7	280",
	"E9	Rolleston	-43.58333	172.38333	60	280",
	"E9	Saint Martins	-43.55533	172.64967	10	280",
	"E9	Scarborough	-43.57461	172.77138	118	280",
	"E9	Sefton	-43.25	172.66667	13	280",
	"E9	Shirley	-43.49833	172.65013	7	280",
	"E9	Sockburn	-43.53263	172.55731	24	280",
	"E9	Somerfield	-43.55931	172.63131	10	280",
	"E9	Southbridge	-43.81667	172.25	22	280",
	"E9	Southshore	-43.5513	172.74839	4	280",
	"E9	Spreydon	-43.5567	172.61689	11	280",
	"E9	Springston	-43.65	172.41667	19	280",
	"E9	Strowan	-43.51014	172.60624	11	280",
	"E9	Templeton	-43.55	172.46667	44	280",
	"E9	Timaru	-44.39672	171.25364	14	280",
	"E9	Tinwald	-43.91667	171.71667	102	280",
	"E9	Tuahiwi	-43.33333	172.65	7	280",
	"E9	Twizel	-44.25842	170.10063	466	280",
	"E9	Upper Riccarton	-43.52833	172.57013	20	280",
	"E9	Waimairi Beach	-43.47833	172.72013	4	280",
	"E9	Waimate	-44.72836	171.05009	61	280",
	"E9	Wainoni	-43.50833	172.68013	5	280",
	"E9	Waltham	-43.54824	172.65156	11	280",
	"E9	Washdyke	-44.35	171.23333	9	280",
	"E9	West Eyreton	-43.35	172.38333	119	280",
	"E9	West Melton	-43.51667	172.36667	96	280",
	"E9	Wigram	-43.55	172.55	21	280",
	"E9	Woodend	-43.31667	172.66667	13	280",
	"F1	Awapuni	-38.65824	177.99021	10	280",
	"F1	Gisborne	-38.65333	178.00417	10	280",
	"F1	Hicks Bay	-37.6	178.3	168	280",
	"F1	Kaiti	-38.66824	178.03021	12	280",
	"F1	Mangapapa	-38.63824	178.01021	17	280",
	"F1	Manutuke	-38.68333	177.91667	6	280",
	"F1	Ruatoria	-37.88333	178.33333	60	280",
	"F1	Tamarau	-38.67824	178.05021	18	280",
	"F1	Te Hapara	-38.64824	177.99021	9	280",
	"F1	Te Karaka	-38.46667	177.86667	45	280",
	"F1	Tiniroto	-38.76667	177.56667	299	280",
	"F1	Tokomaru	-38.13333	178.3	43	280",
	"F1	Tolaga Bay	-38.36667	178.3	10	280",
	"F1	Wainui	-38.68873	178.07048	15	280",
	"F1	Whataupoko	-38.64824	178.02021	16	280",
	"F2	Bay View	-39.42035	176.86727	8	280",
	"F2	Clive	-39.58333	176.91667	6	280",
	"F2	Flaxmere	-39.61824	176.78021	23	280",
	"F2	Hastings	-39.6381	176.84918	19	280",
	"F2	Haumoana	-39.6037	176.94571	6	280",
	"F2	Mahora	-39.61824	176.84021	10	280",
	"F2	Maraenui	-39.50824	176.90022	5	280",
	"F2	Napier	-39.4926	176.91233	6	280",
	"F2	Onekawa	-39.50914	176.88958	4	280",
	"F2	Otane	-39.88333	176.63333	91	280",
	"F2	Raupunga	-39.03333	177.21667	64	280",
	"F2	Raureka	-39.63824	176.82021	16	280",
	"F2	Takapau	-40.03333	176.35	235	280",
	"F2	Taradale	-39.53333	176.85	7	280",
	"F2	Te Awanga	-39.63333	176.98333	7	280",
	"F2	Wairoa	-39.03333	177.36667	58	280",
	"F2	Whakatu	-39.6	176.88333	7	280",
	"F3	Aokautere	-40.36667	175.66667	47	280",
	"F3	Ashhurst	-40.29108	175.75471	81	280",
	"F3	Awapuni	-40.37624	175.58384	27	280",
	"F3	Bulls	-40.17487	175.38463	55	280",
	"F3	Bunnythorpe	-40.28333	175.63333	56	280",
	"F3	Cloverlea	-40.3455	175.59002	28	280",
	"F3	Dannevirke	-40.20549	176.10084	212	280",
	"F3	Foxton	-40.47277	175.28601	8	280",
	"F3	Foxton Beach	-40.46384	175.22716	8	280",
	"F3	Himatangi	-40.39146	175.3153	22	280",
	"F3	Hokowhitu	-40.3626	175.63379	35	280",
	"F3	Jerusalem	-39.55	175.06667	80	280",
	"F3	Kelvin Grove	-40.32875	175.64512	55	280",
	"F3	Levin	-40.63333	175.275	38	280",
	"F3	Linton Military Camp	-40.40309	175.58302	38	280",
	"F3	Mangatainoka	-40.41513	175.86352	100	280",
	"F3	Milson	-40.32825	175.61021	37	280",
	"F3	Moawhango	-39.58016	175.86227	492	280",
	"F3	Pahiatua	-40.45345	175.8406	117	280",
	"F3	Palmerston North	-40.35636	175.61113	34	280",
	"F3	Rongotea	-40.29262	175.42514	31	280",
	"F3	Roslyn	-40.33817	175.62521	46	280",
	"F3	Sanson	-40.22011	175.42445	57	280",
	"F3	Takaro	-40.35793	175.58968	30	280",
	"F3	Terrace End	-40.34825	175.63021	40	280",
	"F3	Tokomaru	-40.473	175.50934	26	280",
	"F3	Waiouru	-39.47753	175.66834	819	280",
	"F3	West End	-40.3659	175.59843	31	280",
	"F3	Whakarongo	-40.33333	175.66667	42	280",
	"F3	Whanganui	-39.93333	175.05	18	280",
	"F4	Blenheim	-41.51603	173.9528	9	280",
	"F4	Havelock	-41.28333	173.76667	27	280",
	"F4	Mayfield	-41.49828	173.95018	10	280",
	"F4	Picton	-41.29067	174.00801	13	280",
	"F4	Rapaura	-41.46667	173.9	18	280",
	"F4	Redwoodtown	-41.52828	173.95018	13	280",
	"F4	Renwick	-41.5	173.83333	37	280",
	"F4	Seddon	-41.66667	174.08333	87	280",
	"F4	Springlands	-41.50851	173.93726	11	280",
	"F4	Waikawa	-41.26667	174.05	35	280",
	"F4	Wairau Valley	-41.56667	173.53333	165	280",
	"F4	Witherlea	-41.52828	173.95018	13	280",
	"F5	Atawhai	-41.23333	173.31667	1	280",
	"F5	Bishopdale	-41.29496	173.26478	57	280",
	"F5	Enner Glynn	-41.30534	173.25414	62	280",
	"F5	Marybank	-41.2276	173.32147	27	280",
	"F5	Moana	-41.27981	173.25427	51	280",
	"F5	Monaco	-41.29827	173.21017	11	280",
	"F5	Nelson	-41.27078	173.28404	11	280",
	"F5	Nelson South	-41.28503	173.27491	47	280",
	"F5	Stoke	-41.31667	173.23333	31	280",
	"F5	Tahunanui	-41.28706	173.24573	8	280",
	"F6	Ahipara	-35.16604	173.15563	14	280",
	"F6	Dargaville	-35.93333	173.88333	8	280",
	"F6	Haruru	-35.28066	174.05434	27	280",
	"F6	Kaeo	-35.1	173.78333	5	280",
	"F6	Kaitaia	-35.11485	173.26366	19	280",
	"F6	Kaiwaka	-36.16667	174.45	48	280",
	"F6	Kawakawa	-35.38333	174.06667	40	280",
	"F6	Kerikeri	-35.22676	173.94739	73	280",
	"F6	Maungatapere	-35.75	174.2	125	280",
	"F6	Maungaturoto	-36.1	174.36667	42	280",
	"F6	Moerewa	-35.38333	174.03333	18	280",
	"F6	Morningside	-35.73481	174.31994	13	280",
	"F6	Ngunguru	-35.61667	174.5	50	280",
	"F6	Ohaeawai	-35.35	173.88333	151	280",
	"F6	Onerahi	-35.76667	174.36667	38	280",
	"F6	Opua	-35.31667	174.11667	20	280",
	"F6	Otangarei	-35.68818	174.31018	104	280",
	"F6	Paihia	-35.28067	174.09103	9	280",
	"F6	Raumanga	-35.74488	174.30578	38	280",
	"F6	Rawene	-35.40217	173.50317	53	280",
	"F6	Ruakaka	-35.90818	174.45019	14	280",
	"F6	Ruawai	-36.13333	174.03333	4	280",
	"F6	Russell	-35.26153	174.12257	8	280",
	"F6	Taipa	-34.99604	173.46665	8	280",
	"F6	Tangiteroria	-35.81667	174.05	9	280",
	"F6	Tikipunga	-35.68818	174.32018	94	280",
	"F6	Waimate North	-35.31667	173.88333	179	280",
	"F6	Waipu	-35.98333	174.45	9	280",
	"F6	Waitangi	-35.27025	174.08062	9	280",
	"F6	Whangarei	-35.73167	174.32391	7	280",
	"F6	Whangarei Heads	-35.81667	174.5	128	280",
	"F7	Alexandra	-45.24837	169.37008	152	280",
	"F7	Andersons Bay	-45.88838	170.5201	17	280",
	"F7	Arrowtown	-44.93837	168.81007	652	280",
	"F7	Arthurs Point	-44.98333	168.66667	363	280",
	"F7	Balclutha	-46.23389	169.75	27	280",
	"F7	Brockville	-45.85838	170.4501	330	280",
	"F7	Cardrona	-44.88333	169	618	280",
	"F7	Caversham	-45.88838	170.4701	112	280",
	"F7	Clyde	-45.18651	169.31545	167	280",
	"F7	Corstorphine	-45.89838	170.4601	86	280",
	"F7	Cromwell	-45.03837	169.20008	212	280",
	"F7	Dunedin	-45.87416	170.50361	21	280",
	"F7	East Taieri	-45.9	170.33333	70	280",
	"F7	Frankton	-45.02125	168.73361	350	280",
	"F7	Green Island	-45.88838	170.4301	120	280",
	"F7	Halfway Bush	-45.85	170.46667	355	280",
	"F7	Kaitangata	-46.275	169.85	7	280",
	"F7	Maori Hill	-45.85838	170.4901	136	280",
	"F7	Maryhill	-45.87838	170.4801	148	280",
	"F7	Milton	-46.12083	169.96944	20	280",
	"F7	Mornington	-45.88333	170.46667	83	280",
	"F7	Musselburgh	-45.88838	170.5101	-9999	280",
	"F7	Oamaru	-45.09758	170.97087	12	280",
	"F7	Opoho	-45.84838	170.5201	145	280",
	"F7	Outram	-45.86667	170.23333	10	280",
	"F7	Palmerston	-45.47837	170.7201	14	280",
	"F7	Papatowai	-46.56069	169.47068	25	280",
	"F7	Pine Hill	-45.83838	170.5201	170	280",
	"F7	Port Chalmers	-45.81664	170.62037	135	280",
	"F7	Portobello	-45.85	170.65	77	280",
	"F7	Queenstown	-45.03023	168.66271	328	280",
	"F7	Ranfurly	-45.13333	170.1	423	280",
	"F7	Ravensbourne	-45.86667	170.55	18	280",
	"F7	Roslyn	-45.86667	170.48333	132	280",
	"F7	Roxburgh	-45.54056	169.31466	101	280",
	"F7	Saint Kilda	-45.89838	170.4901	3	280",
	"F7	Sawyers Bay	-45.81838	170.6001	24	280",
	"F7	Shiel Hill	-45.88838	170.5301	73	280",
	"F7	South Dunedin	-45.88838	170.4901	58	280",
	"F7	Waitati	-45.75	170.56667	15	280",
	"F7	Wakari	-45.84838	170.4801	217	280",
	"F7	Wanaka	-44.7	169.15	325	280",
	"F7	Waverley	-45.87838	170.5201	-9999	280",
	"F7	Weston	-45.08333	170.91667	84	280",
	"F7	Wingatui	-45.88333	170.38333	101	280",
	"F8	Bluff	-46.6	168.33333	31	280",
	"F8	Clifton	-46.44842	168.36009	4	280",
	"F8	East Gore	-46.0884	168.95009	73	280",
	"F8	Edendale	-46.31667	168.78333	43	280",
	"F8	Gore	-46.10282	168.94357	75	280",
	"F8	Hawthorndale	-46.39841	168.38009	15	280",
	"F8	Invercargill	-46.4	168.35	6	280",
	"F8	Mataura	-46.1784	168.85009	64	280",
	"F8	Otatara	-46.43333	168.3	16	280",
	"F8	Otautau	-46.15	168	55	280",
	"F8	Riverton	-46.35	168.01667	7	280",
	"F8	Rosedale	-46.38841	168.36009	5	280",
	"F8	Strathern	-46.42842	168.36009	20	280",
	"F8	Te Anau	-45.41667	167.71667	215	280",
	"F8	Tuatapere	-46.13333	167.68333	24	280",
	"F8	Waikiwi	-46.38333	168.33333	7	280",
	"F8	Wallacetown	-46.33333	168.28333	8	280",
	"F8	Winton	-46.15	168.33333	51	280",
	"F8	Wyndham	-46.33333	168.85	27	280",
	"F9	Bell Block	-39.03333	174.15	34	280",
	"F9	Eltham	-39.42917	174.3	219	280",
	"F9	Fitzroy	-39.05	174.1	27	280",
	"F9	Frankleigh Park	-39.07824	174.0602	68	280",
	"F9	Hawera	-39.59167	174.28333	110	280",
	"F9	Hurdon	-39.07824	174.0402	53	280",
	"F9	Inglewood	-39.15824	174.1802	225	280",
	"F9	Lynmouth	-39.06402	174.05378	35	280",
	"F9	Manaia	-39.55	174.13333	79	280",
	"F9	Mangorei	-39.15	174.08333	212	280",
	"F9	Merrilands	-39.06801	174.09772	38	280",
	"F9	Moturoa	-39.06428	174.03563	39	280",
	"F9	New Plymouth	-39.06667	174.08333	64	280",
	"F9	Normanby	-39.53333	174.28333	110	280",
	"F9	Oakura	-39.11667	173.95	22	280",
	"F9	Okato	-39.2	173.88333	112	280",
	"F9	Opunake	-39.45556	173.85833	32	280",
	"F9	Patea	-39.75833	174.48333	10	280",
	"F9	Puniho	-39.2	173.83333	55	280",
	"F9	Rahotu	-39.33333	173.8	42	280",
	"F9	Ratapiko	-39.2	174.31667	215	280",
	"F9	Spotswood	-39.07224	174.03438	64	280",
	"F9	Stratford	-39.33762	174.28368	315	280",
	"F9	Vogeltown	-39.07824	174.0802	74	280",
	"F9	Waitara	-39.00158	174.23836	8	280",
	"F9	Waverley	-39.76667	174.63333	85	280",
	"F9	Welbourn	-39.07221	174.09094	72	280",
	"F9	Westown	-39.07135	174.06215	65	280",
	"G1	Acacia Bay	-38.70293	176.03085	408	280",
	"G1	Cambridge	-37.87822	175.4402	67	280",
	"G1	Claudelands	-37.78333	175.28333	39	280",
	"G1	Colville	-36.63333	175.46667	33	280",
	"G1	Coromandel	-36.7611	175.49634	7	280",
	"G1	Frankton Junction	-37.8	175.26667	48	280",
	"G1	Hamilton	-37.78333	175.28333	39	280",
	"G1	Hamilton East	-37.78821	175.2902	43	280",
	"G1	Hamilton West	-37.78821	175.2702	44	280",
	"G1	Kawhia	-38.06667	174.81667	19	280",
	"G1	Kerepehi	-37.3	175.53333	6	280",
	"G1	Kihikihi	-38.03333	175.35	69	280",
	"G1	Maramarua	-37.25	175.23333	43	280",
	"G1	Matamata	-37.8106	175.76237	67	280",
	"G1	Ngaruawahia	-37.66738	175.15554	18	280",
	"G1	Ngatea	-37.28333	175.5	5	280",
	"G1	Otorohanga	-38.18333	175.2	39	280",
	"G1	Paeroa	-37.36667	175.66667	9	280",
	"G1	Pauanui	-37.01667	175.86667	13	280",
	"G1	Piopio	-38.46667	175.01667	145	280",
	"G1	Pirongia	-38	175.2	30	280",
	"G1	Pokeno	-37.24502	175.02049	28	280",
	"G1	Port Waikato	-37.39014	174.72755	9	280",
	"G1	Raglan	-37.8	174.88333	31	280",
	"G1	Rangiriri	-37.4305	175.12971	16	280",
	"G1	Tairua	-37.01667	175.85	10	280",
	"G1	Taupiri	-37.61667	175.18333	17	280",
	"G1	Taupo	-38.68333	176.08333	405	280",
	"G1	Te Kauwhata	-37.4	175.15	19	280",
	"G1	Temple View	-37.82077	175.2255	49	280",
	"G1	Te Poi	-37.88333	175.83333	93	280",
	"G1	Te Puru	-37.04658	175.52041	8	280",
	"G1	Thames	-37.13832	175.54011	6	280",
	"G1	Tirau	-37.98333	175.75	151	280",
	"G1	Tokoroa	-38.23333	175.86667	346	280",
	"G1	Turangi	-38.99037	175.80837	383	280",
	"G1	Waharoa	-37.76667	175.76667	54	280",
	"G1	Waihi	-37.38333	175.83333	134	280",
	"G1	Wairakei	-38.63333	176.1	375	280",
	"G1	Waitoa	-37.61667	175.63333	23	280",
	"G1	Whangamata	-37.2	175.86667	7	280",
	"G1	Wharewaka	-38.73105	176.07337	381	280",
	"G1	Whitianga	-36.83333	175.7	8	280",
	"G2	Alicetown	-41.20827	174.89019	72	280",
	"G2	Arakura	-41.22827	174.95019	107	280",
	"G2	Aro Valley	-41.29412	174.76089	75	280",
	"G2	Avalon	-41.19827	174.92019	13	280",
	"G2	Belmont	-41.18827	174.91019	218	280",
	"G2	Boulcott	-41.19827	174.91019	83	280",
	"G2	Brooklyn	-41.30586	174.76257	137	280",
	"G2	Brown Owl	-41.09827	175.0902	90	280",
	"G2	Camborne	-41.08827	174.8702	50	280",
	"G2	Cannons Creek	-41.13992	174.86655	57	280",
	"G2	Carterton	-41.01827	175.5302	84	280",
	"G2	Castlepoint	-40.9	176.21667	27	280",
	"G2	Churton Park	-41.20662	174.80733	120	280",
	"G2	Crofton Downs	-41.25729	174.76218	179	280",
	"G2	Days Bay	-41.28148	174.90719	13	280",
	"G2	Eastbourne	-41.3	174.9	148	280",
	"G2	Epuni	-41.20827	174.92019	11	280",
	"G2	Gladstone	-41.08333	175.65	84	280",
	"G2	Glendale	-41.24827	174.95019	95	280",
	"G2	Grenada North	-41.18969	174.84125	165	280",
	"G2	Hataitai	-41.30431	174.7942	34	280",
	"G2	Heretaunga	-41.13827	175.0202	50	280",
	"G2	Heretaunga	-41.15	175.03333	55	280",
	"G2	Homedale	-41.26828	174.95019	94	280",
	"G2	Houghton Bay	-41.34147	174.7854	11	280",
	"G2	Island Bay	-41.33616	174.77351	9	280",
	"G2	Judgeford	-41.11667	174.93333	21	280",
	"G2	Karaka Bays	-41.30502	174.82879	75	280",
	"G2	Karori	-41.28374	174.74141	184	280",
	"G2	Kelburn	-41.28333	174.76667	100	280",
	"G2	Kelson	-41.17827	174.9302	112	280",
	"G2	Khandallah	-41.245	174.79422	153	280",
	"G2	Kopuaranga	-40.83333	175.66667	188	280",
	"G2	Lower Hutt	-41.21667	174.91667	9	280",
	"G2	Lyall Bay	-41.32731	174.79448	9	280",
	"G2	Maoribank	-41.10827	175.0902	73	280",
	"G2	Masterton	-40.95972	175.6575	103	280",
	"G2	Maungaraki	-41.20827	174.87019	211	280",
	"G2	Maupuia	-41.30347	174.82012	83	280",
	"G2	Melrose	-41.32339	174.78819	97	280",
	"G2	Moera	-41.22827	174.90019	-3	280",
	"G2	Mornington	-41.31862	174.76604	148	280",
	"G2	Mount Cook	-41.30151	174.77476	43	280",
	"G2	Mount Victoria	-41.29696	174.7936	167	280",
	"G2	Naenae	-41.19827	174.94019	14	280",
	"G2	Newlands	-41.22444	174.82192	191	280",
	"G2	Ngaio	-41.25039	174.77394	101	280",
	"G2	Normandale	-41.19827	174.88019	191	280",
	"G2	Northland	-41.28271	174.75626	161	280",
	"G2	Ohariu	-41.2	174.76667	185	280",
	"G2	Onepoto	-41.10827	174.8402	13	280",
	"G2	Oriental Bay	-41.29174	174.79385	14	280",
	"G2	Otaki	-40.75833	175.15	15	280",
	"G2	Owhiro Bay	-41.33828	174.75019	229	280",
	"G2	Paekakariki	-40.98544	174.95449	12	280",
	"G2	Papakowhai	-41.11299	174.86641	33	280",
	"G2	Paparangi	-41.21592	174.81771	164	280",
	"G2	Paraparaumu	-40.91667	175.01667	77	280",
	"G2	Paremata	-41.11667	174.86667	64	280",
	"G2	Parkway	-41.24827	174.92019	194	280",
	"G2	Pauatahanui	-41.1	174.91667	1	280",
	"G2	Petone	-41.22827	174.87019	114	280",
	"G2	Pinehaven	-41.15827	175.0002	217	280",
	"G2	Plimmerton	-41.08333	174.86667	6	280",
	"G2	Porirua	-41.13333	174.85	58	280",
	"G2	Pukerua Bay	-41.03333	174.9	101	280",
	"G2	Raumati Beach	-40.91667	174.98333	11	280",
	"G2	Riverstone Terraces	-41.10827	175.0402	166	280",
	"G2	Roseneath	-41.2909	174.80081	86	280",
	"G2	Seatoun	-41.32484	174.83226	10	280",
	"G2	Silverstream	-41.15	175	103	280",
	"G2	Solway	-40.95827	175.6102	130	280",
	"G2	Stokes Valley	-41.17827	174.9802	52	280",
	"G2	Strathmore Park	-41.32887	174.81986	19	280",
	"G2	Taita	-41.17827	174.9502	19	280",
	"G2	Tawa	-41.17038	174.82613	30	280",
	"G2	Te Aro	-41.294	174.77727	14	280",
	"G2	Te Horo	-40.8	175.1	7	280",
	"G2	Titahi Bay	-41.1	174.83333	12	280",
	"G2	Totara Park	-41.10827	175.0702	182	280",
	"G2	Upper Hutt	-41.13827	175.0502	60	280",
	"G2	Waikanae	-40.88333	175.06667	30	280",
	"G2	Wainuiomata	-41.26667	174.95	93	280",
	"G2	Waipawa	-41.41222	175.51528	238	280",
	"G2	Waitangirua	-41.11827	174.8802	89	280",
	"G2	Waiwhetu	-41.21827	174.91019	7	280",
	"G2	Wallaceville	-41.13333	175.05	57	280",
	"G2	Waterloo	-41.20827	174.92019	11	280",
	"G2	Wellington	-41.28664	174.77557	31	280",
	"G2	Wellington Central	-41.28755	174.77523	24	280",
	"G2	Whitby	-41.10827	174.8902	49	280",
	"G2	Wilton	-41.2691	174.75995	126	280",
	"G2	Woburn	-41.21827	174.90019	2	280",
	"G2	Woodridge	-41.21692	174.83072	211	280",
	"G3	Ahaura	-42.34925	171.53928	72	280",
	"G3	Blaketown	-42.4538	171.19562	5	280",
	"G3	Dobson	-42.45	171.35	55	280",
	"G3	Gloriavale Christian Church	-42.60552	171.70301	240	280",
	"G3	Greymouth	-42.46667	171.2	11	280",
	"G3	Hokitika	-42.71667	170.96667	6	280",
	"G3	Karoro	-42.47314	171.18721	15	280",
	"G3	Reefton	-42.11667	171.86667	199	280",
	"G3	Waikowhai	-43.45	169.88333	51	280",
	"G3	Westport	-41.75262	171.6037	3	280",
	"TAS	Brightwater	-41.38333	173.11667	35	280",
	"TAS	Hope	-41.36667	173.15	35	280",
	"TAS	Mapua	-41.25	173.1	6	280",
	"TAS	Motueka	-41.13333	173.01667	3	280",
	"TAS	Murchison	-41.8	172.33333	172	280",
	"TAS	Richmond	-41.33333	173.18333	10	280",
	"TAS	Riwaka	-41.08333	173	9	280",
	"TAS	Takaka	-40.85	172.8	10	280",
	"TAS	Wakefield	-41.4	173.05	59	280",
];
