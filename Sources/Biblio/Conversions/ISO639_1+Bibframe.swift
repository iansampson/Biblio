//
//  File.swift
//  
//
//  Created by Ian Sampson on 2021-11-20.
//

import LibraryOfCongress

extension Language {
    init?(iso639_1 string: String) {
        guard let iso639_1 = ISO639_1(rawValue: string.lowercased()) else {
            return nil
        }
        
        switch iso639_1 {
        case .ab: self = .abkhaz
        case .aa: self = .afar
        case .af: self = .afrikaans
        case .ak: self = .akan
        case .sq: self = .albanian
        case .am: self = .amharic
        case .ar: self = .arabic
        case .an: self = .aragonese
        case .hy: self = .armenian
        case .as: self = .assamese
        case .av: self = .avaric
        case .ae: self = .avestan
        case .ay: self = .aymara
        case .az: self = .azerbaijani
        case .bm: self = .bambara
        case .ba: self = .bashkir
        case .eu: self = .basque
        case .be: self = . belarusian
        case .bn: self = .bengali
        case .bh: self = .bihari
        case .bi: self = .bislama
        case .bs: self = .bosnian
        case .br: self = .breton
        case .bg: self = .bulgarian
        case .my: self = .burmese
        case .ca: self = .catalan
        case .ch: self = .chamorro
        case .ce: self = .chechen
        case .ny: self = .nyanja
        case .zh: self = .chinese
        case .cv: self = .chuvash
        case .kw: self = .cornish
        case .co: self = .corsican
        case .cr: self = .cree
        case .hr: self = .croatian
        case .cs: self = .czech
        case .da: self = .danish
        case .dv: self = .divehi
        case .nl: self = .dutch
        case .dz: self = .dzongkha
        case .en: self = .english
        case .eo: self = .esperanto
        case .et: self = .estonian
        case .ee: self = .ewe
        case .fo: self = .faroese
        case .fj: self = .fijian
        case .fi: self = .finnish
        case .fr: self = .french
        case .ff: self = .fula
        case .gl: self = .galician
        case .ka: self = .georgian
        case .de: self = .german
        case .el: self = .modernGreek
        case .gn: self = .guarani
        case .gu: self = .gujarati
        case .ht: self = .haitianFrenchCreole
        case .ha: self = .hausa
        case .he: self = .hebrew
        case .hz: self = .herero
        case .hi: self = .hindi
        case .ho: self = .hiriMotu
        case .hu: self = .hungarian
        case .ia: self = .interlingua
        case .id: self = .indonesian
        case .ie: self = .interlingue
        case .ga: self = .irish
        case .ig: self = .igbo
        case .ik: self = .inupiaq
        case .io: self = .ido
        case .is: self = .icelandic
        case .it: self = .italian
        case .iu: self = .inuktitut
        case .ja: self = .japanese
        case .jv: self = .javanese
        case .kl: self = .kalâtdlisut
        case .kn: self = .kannada
        case .kr: self = .kanuri
        case .ks: self = .kashmiri
        case .kk: self = .kazakh
        case .km: self = .khmer
        case .ki: self = .kikuyu
        case .rw: self = .kinyarwanda
        case .ky: self = .kyrgyz
        case .kv: self = .komi
        case .kg: self = .kongo
        case .ko: self = .korean
        case .ku: self = .kurdish
        case .kj: self = .kuanyama
        case .la: self = .latin
        case .lb: self = .luxembourgish
        case .lg: self = .ganda
        case .li: self = .limburgish
        case .ln: self = .lingala
        case .lo: self = .lao
        case .lt: self = .lithuanian
        case .lu: self = .lubaKatanga
        case .lv: self = .latvian
        case .gv: self = .manx
        case .mk: self = .macedonian
        case .mg: self = .malagasy
        case .ms: self = .malay
        case .ml: self = .malayalam
        case .mt: self = .maltese
        case .mi: self = .maori
        case .mr: self = .marathi
        case .mh: self = .marshallese
        case .mn: self = .mongolian
        case .na: self = .nauru
        case .nv: self = .navajo
        case .nd: self = .ndebeleZimbabwe // ZimbabweanNdebele
        case .ne: self = .nepali
        case .ng: self = .ndonga
        case .nb: self = .norwegianBokmål
        case .nn: self = .norwegianNynorsk
        case .no: self = .norwegian
        case .ii: self = .sichuanYi
        case .nr: self = .ndebeleSouthAfrica
        case .oc: self = .occitan
        case .oj: self = .ojibwa
        case .cu: self = .churchSlavic
        case .om: self = .oromo
        case .or: self = .oriya
        case .os: self = .ossetic
        case .pa: self = .panjabi
        case .pi: self = .pali
        case .fa: self = .persian
        // case .pox: self = .polish
        case .pl: self = .polish
        case .ps: self = .pushto
        case .pt: self = .portuguese
        case .qu: self = .quechua
        case .rm: self = .romance
        case .rn: self = .rundi
        case .ro: self = .romanian
        case .ru: self = .russian
        case .sa: self = .sanskrit
        case .sc: self = .sardinian
        case .sd: self = .sindhi
        case .se: self = .northernSami
        case .sm: self = .samoan
        case .sg: self = .sangoUbangiCreole
        case .sr: self = .serbian
        case .gd: self = .scottishGaelic
        case .sn: self = .shona
        case .si: self = .sinhalese
        case .sk: self = .slovak
        case .sl: self = .slovenian
        case .so: self = .somali
        case .st: self = .sotho
        case .es: self = .spanish
        case .su: self = .sundanese
        case .sw: self = .swahili
        case .ss: self = .swazi
        case .sv: self = .swedish
        case .ta: self = .tamil
        case .te: self = .telugu
        case .tg: self = .tajik
        case .th: self = .thai
        case .ti: self = .tigrinya
        case .bo: self = .tibetan
        case .tk: self = .turkmen
        case .tl: self = .tagalog
        case .tn: self = .tswana
        case .to: self = .tonga
        case .tr: self = .turkish
        case .ts: self = .tsonga
        case .tt: self = .tatar
        case .tw: self = .twi
        case .ty: self = .tahitian
        case .ug: self = .uighur
        case .uk: self = .ukrainian
        case .ur: self = .urdu
        case .uz: self = .uzbek
        case .ve: self = .venda
        case .vi: self = .vietnamese
        case .vo: self = .volapük
        case .wa: self = .walloon
        case .cy: self = .welsh
        case .wo: self = .wolof
        case .fy: self = .frisian
        case .xh: self = .xhosa
        case .yi: self = .yiddish
        case .yo: self = .yoruba
        case .za: self = .zhuang
        case .zu: self = .zulu
        }
    }
}
