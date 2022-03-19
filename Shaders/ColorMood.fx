///////////////////////////////////////////////////////////////////////////
// Color Mood
///////////////////////////////////////////////////////////////////////////
// Original code by icelaglace
// Ported to ReShade 2.0 by Marty McFly
// Ported to ReShade 4.0 by Insomnia
// Modified by dddfault
///////////////////////////////////////////////////////////////////////////

// INITIAL SETUP //////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
#include "ReShade.fxh"

// USER INTERFACE /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
uniform float fRatio <
  ui_label    = "Color Mood Intensity";
  ui_tooltip  = "Amount of moody coloring you want";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 1.0;
  ui_step     = 0.01;
  > = 0.3;

uniform float3 moodRGB <
  ui_label    = "Color Mood Adjustment";
  ui_tooltip  = "How strong dark the corresponding colors shall be boosted";
  ui_type     = "drag";
  ui_min      = 0.0;
  ui_max      = 1.0;
  ui_step     = 0.01;
  > = float3(1.0, 1.0, 1.0);

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void PS_ColorMood(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);
  float3 colMood = moodRGB;
  float fLum = ( color.r + color.g + color.b ) / 3.0;
  colMood = lerp(0.0, colMood, saturate(fLum * 2.0));
  colMood = lerp(colMood, 1.0, saturate(fLum - 0.5) * 2.0);
  color.rgb = max(0.0, lerp(color.rgb, colMood, saturate(fLum * fRatio)));
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
technique ColorMood
{
  pass cMood
  {
    VertexShader   = PostProcessVS;
    PixelShader    = PS_ColorMood;
  }
}
