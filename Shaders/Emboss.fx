///////////////////////////////////////////////////////////////////////////
// Emboss
///////////////////////////////////////////////////////////////////////////
// Original code by Marty McFly
// Ported to ReShade 4.0 by Insomnia
// Modified by dddfault
///////////////////////////////////////////////////////////////////////////

// INITIAL SETUP //////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
#include "ReShade.fxh"

// USER INTERFACE /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
uniform float fEmbossPower <
  ui_label    = "Emboss Power";
  ui_type     = "drag";
  ui_min      = 0.1;
  ui_max      = 2.0;
  ui_step     = 0.001;
  > = 0.150;

uniform float fEmbossOffset <
  ui_label    = "Emboss Offset";
  ui_type     = "drag";
  ui_min      = 0.1;
  ui_max      = 5.0;
  ui_step     = 0.001;
  > = 1.00;

uniform float iEmbossAngle <
  ui_label    = "Emboss Angle";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 180.0;
  ui_step     = 0.1;
  > = 90.00;

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void PS_Emboss(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);

  float  colDot, luminance;
  float2 offset;
  float3 col1, col2, col3, colEmboss, colFinal;

  sincos(radians(iEmbossAngle), offset.y, offset.x);

  col1      = tex2D(ReShade::BackBuffer, texcoord.xy - ReShade::PixelSize * fEmbossOffset * offset).rgb;
  col2      = color.rgb;
  col3      = tex2D(ReShade::BackBuffer, texcoord.xy + ReShade::PixelSize * fEmbossOffset * offset).rgb;

  colEmboss = col1 * 2.0 - col2 - col3;
  colDot    = max(0, dot(colEmboss, 0.333)) * fEmbossPower;
  colFinal  = col2 - colDot;

  luminance = dot(col2, float3( 0.6, 0.2, 0.2 ));
  color.rgb = lerp(colFinal, col2, luminance * luminance).rgb;
  color.a   = 1.0;
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
technique Emboss
{
  pass screenEmboss
  {
    VertexShader   = PostProcessVS;
    PixelShader    = PS_Emboss;
  }
}
