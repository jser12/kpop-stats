# not used yet
dict_reason <- c(
  "appload" = "App Launch Resume / Interrupt",
  "fwdbtn" = "Forward Button (Skipped)",
  "playbtn" = "Play Button",
  "popup" = "Popup Play (Preview or Ad)",
  "clickrow" = "Clicked Track in List",
  "backbtn" = "Back Button (Previous)",
  "trackdone" = "Track Finished Naturally",
  "trackerror" = "Track Error",
  "remote" = "Remote Device (Spotify Connect)",
  "unknown" = "Unknown",
  "switched-to-audio" = "Switched to Audio (from Video)",
  "endplay" = "Stopped Manually",
  "logout" = "User Logged Out",
  "unexpected-exit" = "App Closed Unexpectedly",
  "unexpected-exit-while-paused" = "Closed While Paused",
  "switched-to-video" = "Switched to Video"
)

dict_artist <- c(
  # "old name" = "new name"
  "(G)I-DLE" = "i-dle",
  "Girls' Generation" = "SNSD",
  "LIA (ITZY)" = "LIA"
)

dict_kpop <- c(
  # Gen 2
  "Wonder Girls", "Girls' Generation", "SNSD", "KARA", "2NE1", "4Minute",
  "T-ara", "After School", "Brown Eyed Girls", "f(x)", "miss A",
  "Secret", "SISTAR", "Rainbow", "9MUSES", "Dal Shabet",
  "Girl's Day", "Stellar", "Hello Venus", "SPICA", "Crayon Pop",
  
  # Gen 3
  "Red Velvet", "TWICE", "BLACKPINK", "MAMAMOO", "GFRIEND",
  "OH MY GIRL", "LOVELYZ", "DIA", "APRIL", "CLC",
  "WJSN", "I.O.I", "PRISTIN", "fromis_9", "Dreamcatcher", "EXID",
  "LABOUM", "SONAMOO", "Cosmic Girls", "Berry Good", "Weki Meki",
  "Apink", "SATURDAY",
  
  # Gen 4
  "ITZY", "i-dle", "IZ*ONE", "aespa", "STAYC",
  "IVE", "LE SSERAFIM", "NewJeans", "NMIXX", "Kep1er",
  "LOONA", "EVERGLOW", "PURPLE KISS", "Billlie", "Weeekly",
  "Rocket Punch", "LIGHTSUM", "H1-KEY", "CSR", "TRI.BE",
  "VIVIZ",
  
  # Gen 5 (emerging / current)
  "BABYMONSTER", "ILLIT", "KISS OF LIFE", "UNIS",
  "VCHA", "RESCENE", "YOUNG POSSE", "KiiiKiii", "MEOVV", 
  "izna", "Hearts2Hearts", "ifeye", "UAU", "tripleS", "QWER"
)

dict_kpop_gg <- list(
  
  # Gen 2
  "Wonder Girls" = c("Yubin","Yeeun","Sunmi","Hyelim","Hyuna","Sohee","Sunye"),
  "SNSD" = c("Taeyeon","Sunny","Tiffany","Hyoyeon","Yuri","Sooyoung","Yoona","Seohyun","Jessica"),
  "KARA" = c("Seungyeon","Nicole","Jiyoung","Youngji","Hara","Sunghee"), # excluded: Gyuri (re: fromis_9 Gyuri)
  "2NE1" = c("CL","Dara","Bom","Minzy"),
  "4Minute" = c("Jihyun","Gayoon","Jiyoon","Hyuna","Sohyun"),
  "T-ara" = c("Qri","Eunjung","Hyomin","Jiyeon","Boram","Soyeon","Areum","Hwayoung","Jiae","Jiwon","Dani"),
  "f(x)" = c("Victoria","Amber","Luna","Krystal","Sulli"),
  "miss A" = c("Fei","Suzy","Jia","Min"),
  "SISTAR" = c("Hyolyn","Bora","Soyou","Dasom"),
  "Girl's Day" = c("Sojin","Minah","Yura","Hyeri","Jisun","Jiin","Jihae"),
  
  # Gen 3
  "Red Velvet" = c("Irene","Seulgi","Wendy","Joy","Yeri"),
  "TWICE" = c("Jihyo","Nayeon","Jeongyeon","Momo","Sana","Mina","Dahyun","Chaeyoung","Tzuyu"),
  "BLACKPINK" = c("Jisoo","Jennie","Rosé","Lisa"),
  "MAMAMOO" = c("Solar","Moon Byul","Wheein","Hwasa"),
  "WJSN" = c("Exy","Seola","Bona","Soobin","Luda","Dawon","Eunseo","Yeoreum","Dayoung","Yeonjung","Xuan Yi","Cheng Xiao","Mei Qi"),
  "I.O.I" = c("Jeon Somi","KimSejeong","Yoojung","Chung Ha","Sohye","Kyulkyung","Chaeyeon","Doyeon","Mina","Nayoung","Yeonjung"),
  "fromis_9" = c("Hayoung","Jiwon","Nagyung","Jiheon","Saerom","Gyuri","Jisun","Seoyeon"), # excluded: "Chaeyoung" (vs. TWICE)
  "Dreamcatcher" = c("JiU","SuA","Siyeon","Handong","Yoohyeon","Dami","Gahyeon"),
  "EXID" = c("Solji","Elly","Hani","Hyelin","Jeonghwa", "Yuji","Haeryung"), # excluded: Dami (problematic re: Dreamcatcher Dami)
  "SONAMOO" = c("Minjae","D.ana","Nahyun","Euijin","High.D","Newsun"), # excluded: "Sumin" (problematic re: STAYC Sumin and soloist Sumin)
  "GFRIEND" = c("Yuju", "Sowon", "Eunha", "Yerin", "SinB", "Umji"),
  
  # Gen 4
  "ITZY" = c("Yeji","Lia","Ryujin","Chaeryeong","Yuna"),
  "i-dle" = c("Soyeon","Miyeon","Minnie","Yuqi","Shuhua","Soojin"),
  "aespa" = c("Karina","Giselle","Winter","NingNing"),
  "STAYC" = c("Sieun","Isa","Seeun","Yoon","J"), # excluded: # excluded: "Sumin" (problematic re: SONAMOO Sumin and soloist Sumin) 
  "IVE" = c("AnYujin","Gaeul","Rei","JangWonyoung","Liz","Leeseo"),
  "LE SSERAFIM" = c("Kim Chaewon","Sakura","Huh Yunjin","Kazuha","Hong Eunchae","Kim Garam"),
  "NewJeans" = c("Minji","Hanni","Danielle","Haerin","Hyein"),
  "NMIXX" = c("Haewon","Lily","Sullyoon","Bae","Jiwoo","Kyujin","Jinni"),
  "LOONA" = c("HeeJin","HyunJin","HaSeul","YeoJin","ViVi","Kim Lip","JinSoul","Choerry","Yves","Chuu","Go Won","Olivia Hye"),
  "EVERGLOW" = c("Sihyeon","E:U","Onda","Aisha","Yiren","Mia"),
  "IZ*ONE" = c("Lee Chae Yeon", "Yena", "Hyewon", "Nako", "Hitomi", "Jo Yuri"), # included as well: Minju (problematic re: ILLIT Minju), Chaewon & Sakura (LE SSERAFIM), Wonyoung (IVE), AnYujin (IVE)
  
  # Gen 5
  "BABYMONSTER" = c("Ruka","Pharita","Asa","Ahyeon","Rami","Rora","Chiquita"),
  "ILLIT" = c("Yunah","Minju","Moka","Wonhee","Iroha","Youngseo"),
  "KISS OF LIFE" = c("Julie","Natty","Belle","Haneul"),
  "RESCENE" = c("Woni","Liv","Minami","May","Zena"),
  "KiiiKiii" = c("Jiyu","Leesol","Sui","Haum","Kya"),
  "MEOVV" = c("Sooin","Gawon","Anna","Narin","Ella"),
  "izna" = c("Mai","Bang Jeemin","Koko","Ryu Sarang","Choi Jungeun","Jeong Saebi","Yoon Jiyoon"),
  "QWER" = c("Siyeon", "Chodan", "Magenta", "Hina"),
  # soloists
  "soloist" = c("IU", "BIBI", "Song Heejin", "YUKIKA", "SUMIN", "YOUHA")
)

# Moon Byul: NOT upper case, this is an issue (also Song Heejin) 