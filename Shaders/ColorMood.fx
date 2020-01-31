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
#include "Macros.fxh"

// USER INTERFACE /////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
UI_FLOAT_D(fRatio,      "Color Mood Intensity", "Amount of moody coloring you want", 0.0, 1.0, 0.3)
UI_FLOAT3_D(moodRGB,    "Color Mood Adjustment", "How strong dark the corresponding colors shall be boosted", 1.0, 1.0, 1.0)

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void ColorMood(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);
  float3 colMood = moodRGB;
  float fLum = ( color.r + color.g + color.b ) / 3.0;
  colMood = lerp(0.0, colMood, saturate(fLum * 2.0));
  colMood = lerp(colMood, 1.0, saturate(fLum - 0.5) * 2.0);
  color.rgb = max(0.0, lerp(color, colMood, saturate(fLum * fRatio)));
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

TECHNIQUE(ColorMood,
	PASS(1, PostProcessVS, ColorMood)
	)