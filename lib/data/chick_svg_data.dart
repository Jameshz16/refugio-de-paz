/// Contiene las cadenas SVG de los pollitos para cada emoción.
/// Cada pollito tiene un color base diferente y detalles "kawaii" para más carisma.
class ChickSvgData {
  static const Map<String, String> emotions = {
    'Feliz': feliz,
    'Triste': triste,
    'Ansioso': ansioso,
    'Agradecido': agradecido,
    'Cansado': cansado,
    'Temeroso': temeroso,
  };

  // Feliz: Amarillo cálido soleado, ojos grandes brillantes, mejillas muy sonrojadas, copete feliz
  static const String feliz = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <ellipse cx="60" cy="108" rx="30" ry="6" fill="#E0C88A" opacity="0.4"/>
  <ellipse cx="60" cy="72" rx="32" ry="32" fill="#FFD54F"/>
  <!-- Alas felices, más levantaditas -->
  <ellipse cx="28" cy="65" rx="15" ry="22" fill="#FFCA28" transform="rotate(-25 28 65)"/>
  <ellipse cx="28" cy="65" rx="10" ry="18" fill="#FFD54F" transform="rotate(-25 28 65)"/>
  <ellipse cx="92" cy="65" rx="15" ry="22" fill="#FFCA28" transform="rotate(25 92 65)"/>
  <ellipse cx="92" cy="65" rx="10" ry="18" fill="#FFD54F" transform="rotate(25 92 65)"/>
  <circle cx="60" cy="42" r="25" fill="#FFD54F"/>
  <!-- Copete carismático -->
  <path d="M 60 17 Q 66 5 70 18 Q 65 20 60 17" fill="#FFCA28"/>
  <path d="M 60 17 Q 54 8 50 16 Q 55 18 60 17" fill="#FFCA28"/>
  <circle cx="60" cy="17" r="2" fill="#FFCA28"/>
  <!-- Mejillas grandes y rosadas -->
  <ellipse cx="40" cy="48" rx="8" ry="4" fill="#FF8A65" opacity="0.6"/>
  <ellipse cx="80" cy="48" rx="8" ry="4" fill="#FF8A65" opacity="0.6"/>
  <!-- Ojos alegres y brillantes -->
  <circle cx="48" cy="38" r="5.5" fill="#4E342E"/>
  <circle cx="49" cy="36" r="2" fill="white"/>
  <circle cx="46" cy="39" r="1" fill="white"/>
  <circle cx="72" cy="38" r="5.5" fill="#4E342E"/>
  <circle cx="73" cy="36" r="2" fill="white"/>
  <circle cx="70" cy="39" r="1" fill="white"/>
  <!-- Pico sonriente -->
  <path d="M 54 50 Q 60 56 66 50 Q 60 48 54 50" fill="#FF8F00"/>
  <path d="M 56 52 Q 60 58 64 52" fill="#D84315"/>
  <!-- Patitas -->
  <path d="M48 100 L44 108 M48 100 L48 108 M48 100 L52 108" stroke="#FF8F00" stroke-width="3" stroke-linecap="round"/>
  <path d="M72 100 L68 108 M72 100 L72 108 M72 100 L76 108" stroke="#FF8F00" stroke-width="3" stroke-linecap="round"/>
  <!-- Corazoncitos flotantes (kawaii) -->
  <path d="M 25 35 Q 20 30 25 25 Q 30 30 25 35" fill="#E91E63" opacity="0.8"/>
  <path d="M 25 35 Q 30 30 25 25" fill="#E91E63" opacity="0.8"/>
  <path d="M 85 22 Q 80 17 85 12 Q 90 17 85 22" fill="#E91E63" opacity="0.6" transform="scale(0.8) translate(20, -5)"/>
  <path d="M 85 22 Q 90 17 85 12" fill="#E91E63" opacity="0.6" transform="scale(0.8) translate(20, -5)"/>
</svg>
''';

  // Triste: Azul celeste, lágrima gordita, alitas caídas, copete triste
  static const String triste = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <ellipse cx="60" cy="108" rx="30" ry="6" fill="#90B4CE" opacity="0.4"/>
  <ellipse cx="60" cy="74" rx="32" ry="28" fill="#B3D9F2"/>
  <!-- Alas muy caídas -->
  <ellipse cx="30" cy="80" rx="12" ry="18" fill="#90CAF9" transform="rotate(10 30 80)"/>
  <ellipse cx="30" cy="80" rx="8" ry="14" fill="#B3D9F2" transform="rotate(10 30 80)"/>
  <ellipse cx="90" cy="80" rx="12" ry="18" fill="#90CAF9" transform="rotate(-10 90 80)"/>
  <ellipse cx="90" cy="80" rx="8" ry="14" fill="#B3D9F2" transform="rotate(-10 90 80)"/>
  <circle cx="60" cy="46" r="25" fill="#B3D9F2"/>
  <!-- Copete marchito -->
  <path d="M 60 21 Q 65 15 72 24" fill="none" stroke="#90CAF9" stroke-width="3" stroke-linecap="round"/>
  <!-- Mejillas pálidas -->
  <ellipse cx="42" cy="54" rx="6" ry="3" fill="#E3F2FD" opacity="0.8"/>
  <ellipse cx="78" cy="54" rx="6" ry="3" fill="#E3F2FD" opacity="0.8"/>
  <!-- Ojos llorosos enormes -->
  <circle cx="48" cy="42" r="6" fill="#37474F"/>
  <circle cx="49" cy="40" r="2.5" fill="white"/>
  <circle cx="46" cy="44" r="1.5" fill="white"/>
  <circle cx="49" cy="44" r="1" fill="#81D4FA"/>
  
  <circle cx="72" cy="42" r="6" fill="#37474F"/>
  <circle cx="73" cy="40" r="2.5" fill="white"/>
  <circle cx="70" cy="44" r="1.5" fill="white"/>
  <circle cx="73" cy="44" r="1" fill="#81D4FA"/>
  <!-- Cejas tristes (kawaii) -->
  <path d="M 43 36 Q 48 33 53 37" stroke="#37474F" stroke-width="2" fill="none" stroke-linecap="round"/>
  <path d="M 67 37 Q 72 33 77 36" stroke="#37474F" stroke-width="2" fill="none" stroke-linecap="round"/>
  <!-- Pico tembloroso/triste -->
  <path d="M 54 55 Q 60 52 66 55" stroke="#FF8F00" stroke-width="2" fill="none" stroke-linecap="round"/>
  <!-- Lágrima gordita -->
  <path d="M 52 48 Q 48 54 52 56 Q 56 54 52 48" fill="#4FC3F7" opacity="0.9"/>
  <!-- Patitas juntas -->
  <path d="M54 102 L50 108 M54 102 L54 108 M54 102 L58 108" stroke="#FF8F00" stroke-width="2.5" stroke-linecap="round"/>
  <path d="M66 102 L62 108 M66 102 L66 108 M66 102 L70 108" stroke="#FF8F00" stroke-width="2.5" stroke-linecap="round"/>
</svg>
''';

  // Ansioso: Naranja melocotón, pupilas dilatadas, más alboroto, sudor
  static const String ansioso = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <ellipse cx="60" cy="108" rx="30" ry="6" fill="#D4A574" opacity="0.4"/>
  <ellipse cx="61" cy="72" rx="30" ry="32" fill="#FFCC80"/>
  <!-- Alas tiesas hacia arriba (tensión) -->
  <ellipse cx="24" cy="55" rx="12" ry="22" fill="#FFB74D" transform="rotate(-35 24 55)"/>
  <ellipse cx="24" cy="55" rx="8" ry="18" fill="#FFCC80" transform="rotate(-35 24 55)"/>
  <ellipse cx="96" cy="55" rx="12" ry="22" fill="#FFB74D" transform="rotate(35 96 55)"/>
  <ellipse cx="96" cy="55" rx="8" ry="18" fill="#FFCC80" transform="rotate(35 96 55)"/>
  <circle cx="60" cy="42" r="23" fill="#FFCC80"/>
  <!-- Copete erizado -->
  <path d="M 55 19 L 52 8 L 59 16 L 62 5 L 65 17" fill="none" stroke="#FFB74D" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
  <!-- Ojos saltones locos -->
  <circle cx="48" cy="38" r="8" fill="white"/>
  <circle cx="48" cy="38" r="3" fill="#4E342E"/>
  <circle cx="72" cy="38" r="8" fill="white"/>
  <circle cx="72" cy="38" r="3" fill="#4E342E"/>
  <!-- Cejas de preocupación intensa -->
  <path d="M 42 30 Q 48 26 53 32" stroke="#4E342E" stroke-width="2" fill="none" stroke-linecap="round"/>
  <path d="M 67 32 Q 72 26 78 30" stroke="#4E342E" stroke-width="2" fill="none" stroke-linecap="round"/>
  <!-- Pico apretado / mordiéndose -->
  <path d="M 55 52 Q 60 49 65 52" stroke="#FF8F00" stroke-width="2" fill="none" stroke-linecap="round"/>
  <path d="M 56 52 L 56 49 M 60 52 L 60 49 M 64 52 L 64 49" stroke="#FF8F00" stroke-width="1.5"/>
  <!-- Gotas de sudor volando -->
  <path d="M 80 25 Q 76 30 80 33 Q 84 30 80 25" fill="#81D4FA" opacity="0.8"/>
  <path d="M 28 35 Q 25 40 28 43 Q 31 40 28 35" fill="#81D4FA" opacity="0.8"/>
  <path d="M 90 40 Q 87 45 90 48 Q 93 45 90 40" fill="#81D4FA" opacity="0.8"/>
  <!-- Líneas de temblor en el aire -->
  <path d="M 15 65 Q 20 62 18 55" stroke="#4E342E" stroke-width="1.5" fill="none" stroke-linecap="round" opacity="0.5"/>
  <path d="M 105 65 Q 100 62 102 55" stroke="#4E342E" stroke-width="1.5" fill="none" stroke-linecap="round" opacity="0.5"/>
  <!-- Patitas chuecas -->
  <path d="M48 100 L42 108 M48 100 L46 108 M48 100 L50 108" stroke="#E65100" stroke-width="3" stroke-linecap="round"/>
  <path d="M72 100 L70 108 M72 100 L74 108 M72 100 L78 108" stroke="#E65100" stroke-width="3" stroke-linecap="round"/>
</svg>
''';

  // Agradecido: Manitas juntas (alas), aureola más bonita, mejillas súper suaves
  static const String agradecido = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <circle cx="60" cy="55" r="50" fill="#F3E5F5" opacity="0.5"/>
  <ellipse cx="60" cy="108" rx="25" ry="5" fill="#C9A0DC" opacity="0.4"/>
  <ellipse cx="60" cy="70" rx="28" ry="30" fill="#E1BEE7"/>
  <!-- Alitas juntas al frente (orando / agradeciendo) -->
  <ellipse cx="53" cy="72" rx="8" ry="16" fill="#CE93D8" transform="rotate(20 53 72)"/>
  <ellipse cx="67" cy="72" rx="8" ry="16" fill="#CE93D8" transform="rotate(-20 67 72)"/>
  <circle cx="60" cy="42" r="23" fill="#E1BEE7"/>
  <!-- Aureola brillante -->
  <ellipse cx="60" cy="14" rx="16" ry="5" fill="none" stroke="#FFD54F" stroke-width="3" opacity="0.9"/>
  <path d="M 60 5 L 60 9 M 42 14 L 46 14 M 78 14 L 74 14" stroke="#FFD54F" stroke-width="2" stroke-linecap="round" opacity="0.6"/>
  <!-- Mejillas mega adorables -->
  <ellipse cx="43" cy="48" rx="7" ry="4" fill="#F8BBD0" opacity="0.8"/>
  <ellipse cx="77" cy="48" rx="7" ry="4" fill="#F8BBD0" opacity="0.8"/>
  <!-- Ojos cerrados paz absoluta, curva más gruesa -->
  <path d="M 42 40 Q 48 44 54 40" stroke="#4A148C" stroke-width="2.5" fill="none" stroke-linecap="round"/>
  <path d="M 66 40 Q 72 44 78 40" stroke="#4A148C" stroke-width="2.5" fill="none" stroke-linecap="round"/>
  <!-- Pestañas -->
  <path d="M 44 42 L 42 45 M 52 42 L 54 45" stroke="#4A148C" stroke-width="1.5" stroke-linecap="round"/>
  <path d="M 68 42 L 66 45 M 76 42 L 78 45" stroke="#4A148C" stroke-width="1.5" stroke-linecap="round"/>
  <!-- Pico sonrisa pacífica -->
  <path d="M 56 49 Q 60 52 64 49" stroke="#FF8F00" stroke-width="2" fill="none" stroke-linecap="round"/>
  <!-- Estrellitas -->
  <path d="M 25 25 L 28 15 L 31 25 L 41 28 L 31 31 L 28 41 L 25 31 L 15 28 Z" fill="#FFD54F" opacity="0.7" transform="scale(0.6) translate(10, 20)"/>
  <path d="M 85 25 L 88 15 L 91 25 L 101 28 L 91 31 L 88 41 L 85 31 L 75 28 Z" fill="#FFD54F" opacity="0.7" transform="scale(0.4) translate(150, 40)"/>
  <path d="M 50 96 L 46 104 M 50 96 L 50 104 M 50 96 L 54 104" stroke="#FF8F00" stroke-width="2" stroke-linecap="round"/>
  <path d="M 70 96 L 66 104 M 70 96 L 70 104 M 70 96 L 74 104" stroke="#FF8F00" stroke-width="2" stroke-linecap="round"/>
</svg>
''';

  // Cansado: Lavanda, gorrito de dormir, ojeras, burbuja de moco (típica de anime para dormir)
  static const String cansado = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <ellipse cx="60" cy="108" rx="30" ry="6" fill="#B0A8B9" opacity="0.4"/>
  <ellipse cx="60" cy="74" rx="34" ry="26" fill="#D1C4E9"/>
  <!-- Alas escurridas -->
  <ellipse cx="24" cy="78" rx="14" ry="12" fill="#B39DDB" transform="rotate(15 24 78)"/>
  <ellipse cx="24" cy="78" rx="10" ry="8" fill="#D1C4E9" transform="rotate(15 24 78)"/>
  <ellipse cx="96" cy="78" rx="14" ry="12" fill="#B39DDB" transform="rotate(-15 96 78)"/>
  <ellipse cx="96" cy="78" rx="10" ry="8" fill="#D1C4E9" transform="rotate(-15 96 78)"/>
  <circle cx="60" cy="50" r="24" fill="#D1C4E9"/>
  <!-- Gorrito de dormir -->
  <path d="M 36 40 Q 60 15 80 40 Q 60 30 36 40" fill="#9575CD"/>
  <path d="M 80 35 Q 95 30 100 45" stroke="#9575CD" stroke-width="8" fill="none" stroke-linecap="round"/>
  <circle cx="100" cy="48" r="6" fill="#FFF59D"/>
  <circle cx="100" cy="48" r="4" fill="white"/>
  <!-- Ojeras (sombras bajo los ojos) -->
  <ellipse cx="46" cy="52" rx="7" ry="2" fill="#9575CD" opacity="0.3"/>
  <ellipse cx="74" cy="52" rx="7" ry="2" fill="#9575CD" opacity="0.3"/>
  <!-- Ojos entrecerrados pesados -->
  <path d="M 40 48 L 52 48" stroke="#4A148C" stroke-width="2.5" fill="none" stroke-linecap="round"/>
  <path d="M 68 48 L 80 48" stroke="#4A148C" stroke-width="2.5" fill="none" stroke-linecap="round"/>
  <circle cx="46" cy="48" r="2" fill="#4A148C"/>
  <circle cx="74" cy="48" r="2" fill="#4A148C"/>
  <!-- Pico bostezando u hondo -->
  <ellipse cx="60" cy="55" rx="4" ry="6" fill="#FF8F00"/>
  <ellipse cx="60" cy="56" rx="2" ry="4" fill="#E65100"/>
  <!-- Burbuja al dormir (estilo kawaii) -->
  <circle cx="50" cy="54" r="5" fill="#E3F2FD" opacity="0.7" stroke="#90CAF9" stroke-width="1"/>
  <!-- Letras Zzz grandes -->
  <path d="M 20 20 L 30 20 L 20 30 L 30 30" stroke="#7E57C2" stroke-width="2.5" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
  <path d="M 35 15 L 42 15 L 35 22 L 42 22" stroke="#7E57C2" stroke-width="2" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
  <path d="M 12 35 L 18 35 L 12 40 L 18 40" stroke="#7E57C2" stroke-width="1.5" fill="none" stroke-linejoin="round" stroke-linecap="round"/>
  <!-- Patitas chatas -->
  <path d="M48 100 L44 105 M48 100 L48 105 M48 100 L52 105" stroke="#FF8F00" stroke-width="2" stroke-linecap="round"/>
  <path d="M72 100 L68 105 M72 100 L72 105 M72 100 L76 105" stroke="#FF8F00" stroke-width="2" stroke-linecap="round"/>
</svg>
''';

  // Temeroso: Verde menta, alas abrazándose la cara, ojos muy grandes y oscuros, tiritando
  static const String temeroso = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 120">
  <ellipse cx="60" cy="108" rx="25" ry="4" fill="#8FBFA0" opacity="0.4"/>
  <ellipse cx="60" cy="74" rx="26" ry="28" fill="#C8E6C9"/>
  <!-- Cara achatada y tensa -->
  <circle cx="60" cy="48" r="22" fill="#C8E6C9"/>
  <!-- Zona pálida (susto) -->
  <circle cx="60" cy="48" r="16" fill="#E8F5E9" opacity="0.6"/>
  
  <!-- Ojos ENORMES asustados -->
  <circle cx="48" cy="45" r="8.5" fill="white"/>
  <circle cx="48" cy="46" r="4.5" fill="#1B5E20"/>
  <circle cx="49" cy="44" r="1.5" fill="white"/>
  
  <circle cx="72" cy="45" r="8.5" fill="white"/>
  <circle cx="72" cy="46" r="4.5" fill="#1B5E20"/>
  <circle cx="73" cy="44" r="1.5" fill="white"/>
  
  <!-- Cejas de pánico invertidas -->
  <path d="M 40 37 Q 48 33 53 40" stroke="#1B5E20" stroke-width="1.5" fill="none" stroke-linecap="round"/>
  <path d="M 67 40 Q 72 33 80 37" stroke="#1B5E20" stroke-width="1.5" fill="none" stroke-linecap="round"/>
  
  <!-- Pico pequeño y tembloroso -->
  <path d="M 57 56 L 63 56 L 60 59 Z" fill="#FF8F00"/>
  <path d="M 57 56 Q 60 54 63 56" fill="#FF8F00"/>
  
  <!-- Alas tapándose un poco la cara (modo burrito) -->
  <ellipse cx="42" cy="65" rx="10" ry="18" fill="#A5D6A7" transform="rotate(35 42 65)"/>
  <ellipse cx="42" cy="65" rx="6" ry="14" fill="#C8E6C9" transform="rotate(35 42 65)"/>
  <ellipse cx="78" cy="65" rx="10" ry="18" fill="#A5D6A7" transform="rotate(-35 78 65)"/>
  <ellipse cx="78" cy="65" rx="6" ry="14" fill="#C8E6C9" transform="rotate(-35 78 65)"/>
  
  <!-- Líneas de susto verticales clásicas (anime) -->
  <path d="M 40 20 L 40 28 M 46 15 L 46 25 M 74 15 L 74 25 M 80 20 L 80 28" stroke="#81C784" stroke-width="1.5" stroke-linecap="round" opacity="0.7"/>
  
  <!-- Tiritar (ondas pequeñas) -->
  <path d="M 28 50 Q 25 55 28 60 Q 25 65 28 70" stroke="#4CAF50" stroke-width="1.5" fill="none" opacity="0.4"/>
  <path d="M 92 50 Q 95 55 92 60 Q 95 65 92 70" stroke="#4CAF50" stroke-width="1.5" fill="none" opacity="0.4"/>
  
  <!-- Patitas apretadas -->
  <path d="M56 100 L54 108 M56 100 L56 108 M56 100 L58 108" stroke="#FF8F00" stroke-width="2" stroke-linecap="round"/>
  <path d="M64 100 L62 108 M64 100 L64 108 M64 100 L66 108" stroke="#FF8F00" stroke-width="2" stroke-linecap="round"/>
</svg>
''';
}
