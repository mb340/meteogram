const CITIES = [
	"01	Agarakavan	40.33069	44.07233	1445	6",
	"01	Aparan	40.59323	44.3589	1892	6",
	"01	Aragats	40.48889	44.3529	1976	6",
	"01	Arteni	40.2973	43.76672	1206	6",
	"01	Ashnak	40.33069	43.91669	1429	6",
	"01	Ashtarak	40.2991	44.36204	1142	6",
	"01	Byurakan	40.33894	44.27275	1489	6",
	"01	Hnaberd	40.63721	44.14058	2110	6",
	"01	Karbi	40.33069	44.37793	1305	6",
	"01	Kasakh	40.53697	44.41046	1857	6",
	"01	Kosh	40.30011	44.16107	1205	6",
	"01	Nor Yerznka	40.30011	44.38892	1193	6",
	"01	Oshakan	40.26392	44.31671	1051	6",
	"01	Sasunik	40.25012	44.34448	1071	6",
	"01	Shenavan	40.48328	44.38348	1881	6",
	"01	T’alin	40.39172	43.87793	1631	6",
	"01	Tsaghkahovit	40.63428	44.22241	2108	6",
	"01	Ushi	40.34729	44.37512	1394	6",
	"01	Voskevaz	40.27508	44.30011	1042	6",
	"01	Zovuni	40.51111	44.4389	1856	6",
	"02	Abovyan	40.04851	44.54742	956	6",
	"02	Aralez	39.90008	44.6557	856	6",
	"02	Ararat	39.83069	44.70569	823	6",
	"02	Arevabuyr	40.03607	44.46948	834	6",
	"02	Arevshat	40.03963	44.54179	931	6",
	"02	Armash	39.76672	44.8111	840	6",
	"02	Artashat	39.96144	44.54447	830	6",
	"02	Avshar	39.85553	44.65832	832	6",
	"02	Aygavan	39.87327	44.66984	847	6",
	"02	Aygepat	39.95845	44.59981	880	6",
	"02	Aygestan	40.00293	44.55829	869	6",
	"02	Aygezard	39.95436	44.60229	877	6",
	"02	Bardzrashen	40.08533	44.57957	1154	6",
	"02	Berk’anush	39.9779	44.51672	836	6",
	"02	Burastan	39.99157	44.49681	839	6",
	"02	Byuravan	40.01604	44.51889	868	6",
	"02	Dalar	39.97653	44.52649	839	6",
	"02	Darakert	40.10553	44.41388	844	6",
	"02	Dashtavan	40.1001	44.39172	836	6",
	"02	Dimitrov	40.00848	44.4917	845	6",
	"02	Dvin	40.01984	44.58376	928	6",
	"02	Getazat	40.03844	44.56369	939	6",
	"02	Ghukasavan	40.12793	44.41669	851	6",
	"02	Goravan	39.90832	44.73328	922	6",
	"02	Hayanist	40.12231	44.37793	843	6",
	"02	Hovtashat	40.09729	44.34448	836	6",
	"02	Hovtashen	40.02508	44.45007	826	6",
	"02	Jrahovit	40.0473	44.4751	837	6",
	"02	Lusarrat	39.87403	44.58678	821	6",
	"02	Marmarashen	40.05829	44.47229	847	6",
	"02	Masis	40.06572	44.41913	835	6",
	"02	Mrganush	40.02857	44.55831	908	6",
	"02	Mrgavan	39.97251	44.53565	840	6",
	"02	Mrgavet	40.02789	44.48328	842	6",
	"02	Nizami	40.09168	44.4057	838	6",
	"02	Norabats’	40.10553	44.43329	864	6",
	"02	Noramarg	40.02228	44.42511	829	6",
	"02	Norashen	40.0013	44.59296	906	6",
	"02	Noyakert	39.83069	44.66949	827	6",
	"02	Nshavan	40.02787	44.52565	886	6",
	"02	Rranch’par	40.02789	44.36951	833	6",
	"02	Sayat’-Nova	40.07507	44.40008	833	6",
	"02	Shahumyan	39.94171	44.57233	832	6",
	"02	Sis	40.05829	44.38892	829	6",
	"02	Sisavan	39.90802	44.66721	865	6",
	"02	Surenavan	39.79449	44.77508	821	6",
	"02	Vedi	39.91388	44.7251	914	6",
	"02	Verin Artashat	39.99731	44.58893	893	6",
	"02	Verin Dvin	40.02434	44.59038	955	6",
	"02	Vosketap’	39.88114	44.64917	841	6",
	"02	Vostan	39.96515	44.55937	837	6",
	"02	Yeghegnavan	39.83893	44.61951	816	6",
	"02	Zangakatun	39.82233	45.04169	1679	6",
	"02	Zorak	40.09168	44.39447	835	6",
	"03	Aghavnatun	40.2333	44.25295	931	6",
	"03	Aknalich	40.14728	44.16669	862	6",
	"03	Aknashen	40.09551	44.28604	838	6",
	"03	Alashkert	40.10712	44.05108	857	6",
	"03	Apaga	40.09729	44.25293	843	6",
	"03	Arak’s	40.05548	44.30292	837	6",
	"03	Arazap’	40.04169	44.14728	847	6",
	"03	Arbat’	40.13892	44.40289	856	6",
	"03	Arevashat	40.14447	44.37512	853	6",
	"03	Arevik	40.1001	44.09448	853	6",
	"03	Argavand	40.0611	44.09448	855	6",
	"03	Armavir	40.15446	44.03815	870	6",
	"03	Arshaluys	40.16949	44.21393	868	6",
	"03	Artimet	40.15008	44.26672	859	6",
	"03	Aygek	40.1889	44.38611	948	6",
	"03	Aygeshat	40.07507	44.0611	859	6",
	"03	Aygeshat	40.23608	44.28888	942	6",
	"03	Baghramyan	40.19452	44.36951	947	6",
	"03	Bambakashat	40.10828	44.01947	865	6",
	"03	Dalarik	40.2279	43.87793	1005	6",
	"03	Doghs	40.22229	44.27228	926	6",
	"03	Gay	40.08444	44.30528	840	6",
	"03	Geghakert	40.18516	44.24331	883	6",
	"03	Geghanist	40.14587	44.43048	868	6",
	"03	Getashen	40.04449	43.94171	888	6",
	"03	Gmbet’	40.22369	44.25409	917	6",
	"03	Griboyedov	40.11307	44.27169	845	6",
	"03	Haykashen	40.07233	44.30829	837	6",
	"03	Hovtamej	40.18329	44.25848	885	6",
	"03	Janfida	40.04449	44.02789	866	6",
	"03	Khoronk’	40.13611	44.24731	858	6",
	"03	Lenughi	40.12512	43.96393	887	6",
	"03	Lukashin	40.18726	44.0039	874	6",
	"03	Margara	40.03332	44.18048	843	6",
	"03	Mayisyan	40.15701	44.09192	874	6",
	"03	Merdzavan	40.1814	44.40033	939	6",
	"03	Metsamor	40.07233	44.29169	840	6",
	"03	Metsamor	40.14447	44.1167	861	6",
	"03	Mrgashat	40.13068	44.08069	849	6",
	"03	Musalerr	40.1557	44.37793	862	6",
	"03	Myasnikyan	40.18048	43.91949	906	6",
	"03	Nalbandyan	40.0639	43.98889	870	6",
	"03	Norakert	40.19733	44.3501	942	6",
	"03	Nor Armavir	40.08612	43.99451	888	6",
	"03	P’shatavan	40.03888	44.06671	860	6",
	"03	Ptghunk’	40.16388	44.36389	868	6",
	"03	Sardarapat	40.13206	44.00969	862	6",
	"03	Shenavan	40.05548	43.93048	896	6",
	"03	Tandzut	40.06952	44.07788	854	6",
	"03	Taronik	40.13367	44.19957	851	6",
	"03	Tsaghkunk’	40.18048	44.27228	886	6",
	"03	Tsiatsan	40.1861	44.26947	886	6",
	"03	Vagharshapat	40.16557	44.29462	877	6",
	"03	Voskehat	40.14172	44.33069	857	6",
	"03	Yeghegnut	40.08893	44.16669	847	6",
	"03	Yeraskhahun	40.07233	44.21948	843	6",
	"04	Akunk’	40.14954	45.66335	2088	6",
	"04	Astghadzor	40.12231	45.35553	2035	6",
	"04	Aygut	40.68298	45.17634	1427	6",
	"04	Chambarak	40.59655	45.35498	1848	6",
	"04	Ddmashen	40.57028	44.82295	1798	6",
	"04	Drakhtik	40.56497	45.2367	1983	6",
	"04	Dzoragyugh	40.16957	45.18337	2016	6",
	"04	Gagarin	40.54026	44.86962	1891	6",
	"04	Gandzak	40.31472	45.11139	1989	6",
	"04	Gavar	40.35398	45.12386	1953	6",
	"04	Geghamasar	40.31091	45.67924	2047	6",
	"04	Geghamavan	40.5625	44.88892	1853	6",
	"04	Karanlukh	40.10444	45.28972	2111	6",
	"04	Karchaghbyur	40.17048	45.57785	1950	6",
	"04	Lanjaghbyur	40.26947	45.14447	2042	6",
	"04	Lchap	40.45569	45.07507	1931	6",
	"04	Lchashen	40.51947	44.93048	1929	6",
	"04	Lichk’	40.15933	45.23467	1930	6",
	"04	Madina	40.07637	45.25507	2169	6",
	"04	Martuni	40.13892	45.30548	1935	6",
	"04	Mets Masrik	40.21948	45.76391	1943	6",
	"04	Nerkin Getashen	40.14172	45.27087	1936	6",
	"04	Noratus	40.37793	45.18048	1926	6",
	"04	Sarukhan	40.29169	45.13068	1990	6",
	"04	Sevan	40.5473	44.94171	1934	6",
	"04	Tsovagyugh	40.63348	44.96112	2016	6",
	"04	Tsovak	40.18254	45.63286	1923	6",
	"04	Tsovasar	40.1382	45.19096	2100	6",
	"04	Tsovazard	40.4751	45.05011	1944	6",
	"04	Tsovinar	40.15959	45.46786	1926	6",
	"04	Vaghashen	40.13611	45.33069	1957	6",
	"04	Vahan	40.57549	45.39769	1925	6",
	"04	Vardenik	40.13348	45.44311	1971	6",
	"04	Vardenis	40.18329	45.73053	1939	6",
	"04	Varser	40.55548	44.90832	1917	6",
	"04	Verin Getashen	40.13068	45.25293	1980	6",
	"04	Yeranos	40.20428	45.19209	1982	6",
	"05	Abovyan	40.27368	44.63348	1423	6",
	"05	Aghavnadzor	40.58195	44.69581	1771	6",
	"05	Akunk’	40.26672	44.6861	1459	6",
	"05	Aragyugh	40.40289	44.54449	1631	6",
	"05	Aramus	40.25095	44.66351	1441	6",
	"05	Argel	40.37793	44.6001	1430	6",
	"05	Arzakan	40.45007	44.60828	1483	6",
	"05	Arzni	40.2973	44.59869	1349	6",
	"05	Balahovit	40.25153	44.60828	1409	6",
	"05	Bjni	40.45831	44.65008	1490	6",
	"05	Buzhakan	40.45569	44.51947	1845	6",
	"05	Byureghavan	40.31417	44.59333	1385	6",
	"05	Ch’arents’avan	40.40289	44.64447	1661	6",
	"05	Dzoraghbyur	40.20412	44.6415	1549	6",
	"05	Fantan	40.39447	44.6861	1801	6",
	"05	Garrni	40.11931	44.73442	1413	6",
	"05	Goght’	40.1347	44.78332	1578	6",
	"05	Hrazdan	40.49748	44.7662	1762	6",
	"05	Kaputan	40.32507	44.70007	1765	6",
	"05	Kotayk’	40.27789	44.66388	1443	6",
	"05	Lerrnanist	40.46676	44.79249	1922	6",
	"05	Mayakovski	40.25293	44.63892	1418	6",
	"05	Meghradzor	40.60611	44.65147	1785	6",
	"05	Mrgashen	40.28607	44.54449	1335	6",
	"05	Nor Geghi	40.32233	44.58331	1313	6",
	"05	Nor Gyugh	40.26672	44.65832	1432	6",
	"05	Prroshyan	40.24731	44.41949	1185	6",
	"05	Ptghni	40.25568	44.58612	1336	6",
	"05	Solak	40.46252	44.70709	1658	6",
	"05	Tsaghkadzor	40.53259	44.72025	1861	6",
	"05	Yeghvard	40.32507	44.48608	1343	6",
	"05	Zarr	40.25848	44.73328	1622	6",
	"05	Zoravan	40.35553	44.52228	1469	6",
	"05	Zovaber	40.56671	44.79028	1765	6",
	"06	Agarak	41.01072	44.46845	1375	6",
	"06	Akht’ala	41.16838	44.75811	1214	6",
	"06	Alaverdi	41.09766	44.67316	699	6",
	"06	Arevashogh	40.86039	44.27438	1680	6",
	"06	Bazum	40.86763	44.43978	1521	6",
	"06	Chochkan	41.18118	44.83217	767	6",
	"06	Darpas	40.83674	44.42494	1377	6",
	"06	Dsegh	40.9617	44.65003	1216	6",
	"06	Fioletovo	40.72241	44.71769	1686	6",
	"06	Gogaran	40.89255	44.19915	1849	6",
	"06	Gugark	40.8046	44.54025	1320	6",
	"06	Gyulagarak	40.96715	44.47144	1366	6",
	"06	Jrashen	40.79028	44.18664	1676	6",
	"06	Lerrnants’k’	40.79532	44.27435	1667	6",
	"06	Lerrnapat	40.81538	44.39344	1524	6",
	"06	Lerrnavan	40.7882	44.16024	1778	6",
	"06	Lorut	40.93717	44.77142	1499	6",
	"06	Margahovit	40.73381	44.68474	1752	6",
	"06	Metsavan	41.20156	44.22877	1576	6",
	"06	Mets Parni	40.83472	44.11108	1697	6",
	"06	Norashen	41.18886	44.33336	1586	6",
	"06	Odzun	41.05321	44.61341	1107	6",
	"06	Sarahart’	40.87043	44.21407	1733	6",
	"06	Saramej	40.77487	44.2222	1780	6",
	"06	Shahumyan	40.77482	44.54596	1520	6",
	"06	Shnogh	41.14693	44.84043	640	6",
	"06	Spitak	40.83221	44.26731	1548	6",
	"06	Stepanavan	41.00995	44.38531	1405	6",
	"06	Tashir	41.12072	44.28462	1505	6",
	"06	Tsaghkaber	40.79849	44.10144	1762	6",
	"06	Urrut	41.06778	44.39628	1459	6",
	"06	Vahagni	40.90698	44.60873	1076	6",
	"06	Vanadzor	40.80456	44.4939	1344	6",
	"06	Vardablur	40.97083	44.50889	1318	6",
	"06	Yeghegnut	40.90302	44.63155	1096	6",
	"07	Akhuryan	40.78003	43.90027	1544	6",
	"07	Amasia	40.95442	43.7872	1877	6",
	"07	Anushavan	40.65008	43.98053	1722	6",
	"07	Arevik	40.7417	43.9043	1532	6",
	"07	Arevshat	40.65345	44.04419	1913	6",
	"07	Arrap’i	40.78276	43.80583	1487	6",
	"07	Azatan	40.71959	43.82727	1498	6",
	"07	Basen	40.75767	43.99274	1638	6",
	"07	Dzit’hank’ov	40.50848	43.82092	1751	6",
	"07	Gyumri	40.7942	43.84528	1549	6",
	"07	Haykavan	40.80312	43.75173	1557	6",
	"07	Horrom	40.65973	43.89032	1578	6",
	"07	Kamo	40.82572	43.95071	1642	6",
	"07	Lerrnakert	40.5625	43.9389	1984	6",
	"07	Maralik	40.57507	43.87231	1713	6",
	"07	Marmashen	40.83486	43.7779	1619	6",
	"07	Mayisyan	40.84715	43.83938	1642	6",
	"07	Meghrashen	40.6723	43.95831	1664	6",
	"07	Mets Mant’ash	40.64376	44.05653	1962	6",
	"07	Pemzashen	40.58612	43.94311	1803	6",
	"07	P’ok’r Mant’ash	40.64026	44.04666	1977	6",
	"07	Saratak	40.6709	43.87231	1561	6",
	"07	Shirak	40.84042	43.91582	1634	6",
	"07	Spandaryan	40.66105	44.01551	1825	6",
	"07	Voskehask	40.76426	43.77474	1495	6",
	"07	Yerazgavors	40.69505	43.74722	1452	6",
	"08	Agarak	39.20684	46.5446	998	6",
	"08	Akner	39.53491	46.30732	1641	6",
	"08	Angeghakot’	39.56952	45.94452	1822	6",
	"08	Brrnakot’	39.49742	45.97241	1698	6",
	"08	Dzorastan	39.27059	46.3572	1206	6",
	"08	Gorayk’	39.68183	45.76149	2105	6",
	"08	Goris	39.51111	46.34168	1351	6",
	"08	Hats’avan	39.46405	45.97047	1761	6",
	"08	Kapan	39.20755	46.40576	774	6",
	"08	Khndzoresk	39.50568	46.4361	1408	6",
	"08	Meghri	38.90292	46.24458	657	6",
	"08	Shaghat	39.55698	45.90727	1796	6",
	"08	Shinuhayr	39.4367	46.31787	1500	6",
	"08	Tat’ev	39.38611	46.24451	1598	6",
	"08	Tegh	39.55826	46.48054	1318	6",
	"08	Verishen	39.53543	46.32063	1621	6",
	"09	Archis	41.16351	44.87631	754	6",
	"09	Artsvaberd	40.83947	45.47033	1285	6",
	"09	Aygehovit	40.97951	45.25033	697	6",
	"09	Azatamut	40.98204	45.18551	547	6",
	"09	Bagratashen	41.24358	44.81737	440	6",
	"09	Berd	40.88135	45.38901	949	6",
	"09	Berdavan	41.20503	44.99967	705	6",
	"09	Dilijan	40.7417	44.8501	1315	6",
	"09	Gosh	40.73053	45.00012	1212	6",
	"09	Haghartsin	40.77614	44.96847	1015	6",
	"09	Ijevan	40.87877	45.14851	677	6",
	"09	Khasht’arrak	40.93668	45.1821	816	6",
	"09	Mosesgegh	40.90534	45.48838	817	6",
	"09	Navur	40.86695	45.34179	1482	6",
	"09	Noyemberyan	41.17244	44.99917	842	6",
	"09	Parravak’ar	40.98248	45.36696	768	6",
	"09	Sarigyugh	41.03531	45.14486	828	6",
	"09	Voskevan	41.12081	45.06381	946	6",
	"10	Agarakadzor	39.73608	45.35553	1143	6",
	"10	Aghavnadzor	39.78607	45.2279	1553	6",
	"10	Areni	39.71668	45.18329	1081	6",
	"10	Getap’	39.76392	45.30829	1118	6",
	"10	Gladzor	39.7807	45.34729	1378	6",
	"10	Jermuk	39.84168	45.66949	2103	6",
	"10	Malishka	39.74731	45.4057	1260	6",
	"10	Rrind	39.76111	45.17792	1316	6",
	"10	Shatin	39.83612	45.30292	1276	6",
	"10	Vayk’	39.6889	45.46668	1237	6",
	"10	Vernashen	39.79236	45.36389	1543	6",
	"10	Yeghegis	39.87231	45.3501	1573	6",
	"10	Yeghegnadzor	39.76389	45.33239	1242	6",
	"10	Zarrit’ap’	39.63892	45.51111	1512	6",
	"11	Argavand	40.15289	44.4389	881	6",
	"11	Jrashen	40.05275	44.51259	941	6",
	"11	K’anak’erravan	40.24739	44.53511	1252	6",
	"11	Vardadzor	40.18701	45.19212	1997	6",
	"11	Yerevan	40.18111	44.51361	994	6",
];
