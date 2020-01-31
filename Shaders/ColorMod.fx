///////////////////////////////////////////////////////////////////////////
// Color Mod
///////////////////////////////////////////////////////////////////////////
// Original code by Ryosuke839
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
UI_FLOAT_D(cmodChroma,      "Color Mod Chroma", "Saturation adjustment for corresponding color", 0.0, 1.0, 0.7)
UI_FLOAT3_D(cmodGamma,      "Color Mod Gamma", "Gamma adjustment for corresponding color", 1.0, 1.0, 1.0)
UI_FLOAT3_D(cmodContrast,   "Color Mod Contrast", "Contrast adjustment for corresponding color", 1.0, 1.0, 1.0)
UI_FLOAT3_D(cmodBrightness, "Color Mod Brightness", "Brightness adjustment for corresponding color", 0.0, 0.0, 0.0)

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void ColorMod(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);
  color.rgb = (color.rgb - dot(color.rgb, 0.333)) * cmodChroma + dot(color.rgb, 0.333);
	color.rgb = saturate(color.rgb);
	color.r = (pow(color.r, cmodGamma.x) - 0.5) * cmodContrast.x + 0.5 + cmodBrightness.x;
	color.g = (pow(color.g, cmodGamma.y) - 0.5) * cmodContrast.y + 0.5 + cmodBrightness.y;
	color.b = (pow(color.b, cmodGamma.z) - 0.5) * cmodContrast.z + 0.5 + cmodBrightness.z;
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

TECHNIQUE(ColorMod,
	PASS(1, PostProcessVS, ColorMod)
	)
