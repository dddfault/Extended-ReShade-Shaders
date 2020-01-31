///////////////////////////////////////////////////////////////////////////
// Cross Process
///////////////////////////////////////////////////////////////////////////
// Original code by AgaintsAllAuthority / opezdl
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
UI_FLOAT_S(CrossContrast, "Contrast", "Cross Process Contast", 0.0, 2.0, 1.0)
UI_FLOAT_S(CrossSaturation, "Saturation", "Cross Process Saturation", 0.0, 2.0, 1.0)
UI_FLOAT_S(CrossBrightness, "Brightness", "Cross Process Brightness", -1.0, 1.0, 0.0)
UI_FLOAT_S(CrossAmount, "Amount", "Cross Process Intensity", 0.05, 1.5, 0.5)

// PIXEL SHADER ///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void XProcess(float4 vpos : SV_Position, float2 texcoord : TEXCOORD, out float4 color : SV_Target0)
{
  color     = tex2D(ReShade::BackBuffer, texcoord.xy);

	float2 CrossMatrix [3] = {
		float2 (1.03, 0.04),
		float2 (1.09, 0.01),
		float2 (0.78, 0.13),
 		};

	float3 image1 = color.rgb;
	float3 image2 = color.rgb;
	float gray = dot(float3(0.5,0.5,0.5), image1);
	image1 = lerp (gray, image1, CrossSaturation);
	image1 = lerp (0.35, image1, CrossContrast);
	image1 += CrossBrightness;
	image2.r = image1.r * CrossMatrix[0].x + CrossMatrix[0].y;
	image2.g = image1.g * CrossMatrix[1].x + CrossMatrix[1].y;
	image2.b = image1.b * CrossMatrix[2].x + CrossMatrix[2].y;
	color.rgb = lerp(image1, image2, CrossAmount);
}

// TECHNIQUE //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

TECHNIQUE(CrossProcess,
	PASS(1, PostProcessVS, XProcess)
	)
