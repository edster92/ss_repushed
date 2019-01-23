// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyShaders/MyOpaque"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_TintColor("TintColor", Color) = (1,1,1,0)
		_AlbedoIntense("AlbedoIntense", Float) = 1
		_Normal("Normal", 2D) = "bump" {}
		_MFIntense("MFIntense", Float) = 1
		_MSAO("MSAO", 2D) = "white" {}
		_Metallness("Metallness", Float) = 1
		_Smoothness("Smoothness", Float) = 1
		_Tiling("Tiling", Float) = 1
		_AO("AO", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float _Tiling;
		uniform float _MFIntense;
		uniform float4 _TintColor;
		uniform float _AlbedoIntense;
		uniform sampler2D _Albedo;
		uniform float _Metallness;
		uniform sampler2D _MSAO;
		uniform float _Smoothness;
		uniform float _AO;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_19_0 = ( i.uv_texcoord * _Tiling );
			float3 break6_g1 = UnpackNormal( tex2D( _Normal, temp_output_19_0 ) );
			float2 appendResult1_g1 = (float2(break6_g1.x , break6_g1.y));
			float3 appendResult4_g1 = (float3(( appendResult1_g1 * _MFIntense ) , break6_g1.z));
			o.Normal = appendResult4_g1;
			o.Albedo = ( _TintColor * ( _AlbedoIntense * tex2D( _Albedo, temp_output_19_0 ) ) ).rgb;
			float4 tex2DNode3 = tex2D( _MSAO, temp_output_19_0 );
			o.Metallic = ( _Metallness * tex2DNode3.r );
			o.Smoothness = ( _Smoothness * tex2DNode3.g );
			o.Occlusion = pow( _AO , tex2DNode3.b );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=15600
6.4;28.8;1523;790;1566.283;299.0981;1.3;True;True
Node;AmplifyShaderEditor.RangedFloatNode;18;-904.5839,12.25188;Float;False;Property;_Tiling;Tiling;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;17;-959.1832,-113.8482;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-719.983,-94.34814;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;-518.5,-110.5;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;None;9e16eac54c72886449539e97a6a77188;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-413.5,-192;Float;False;Property;_AlbedoIntense;AlbedoIntense;2;0;Create;True;0;0;False;0;1;2.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-157.0824,211.8019;Float;False;Property;_AO;AO;10;0;Create;True;0;0;False;0;1;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;5;-433.5,-366;Float;False;Property;_TintColor;TintColor;1;0;Create;True;0;0;False;0;1,1,1,0;0.8679245,0.7471164,0.5363119,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-171.3824,114.3019;Float;False;Property;_Smoothness;Smoothness;8;0;Create;True;0;0;False;0;1;0.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-516.5,76.5;Float;True;Property;_Normal;Normal;3;0;Create;True;0;0;False;0;None;62ad9216873d95d41a9ec528f74bbf8a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-194.5,-167;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-170.0824,27.20182;Float;False;Property;_Metallness;Metallness;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-515.5,266.5;Float;True;Property;_MSAO;MSAO;6;0;Create;True;0;0;False;0;None;e4182d48e600c3149a829c892b2dcd48;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;16;-1.082412,356.7521;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;8;-157.0386,-64.90463;Float;False;NormalIntense;4;;1;30562070d452005448884f54efb60ac5;0;1;5;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;0.2176008,243.002;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-50.5,-237;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-2.382383,44.10179;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-2.382382,146.8019;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;211.6258,14.47014;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;MyShaders/MyOpaque;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;1;1;19;0
WireConnection;2;1;19;0
WireConnection;6;0;4;0
WireConnection;6;1;1;0
WireConnection;3;1;19;0
WireConnection;16;0;15;0
WireConnection;16;1;3;3
WireConnection;8;5;2;0
WireConnection;14;0;15;0
WireConnection;14;1;3;3
WireConnection;7;0;5;0
WireConnection;7;1;6;0
WireConnection;10;0;9;0
WireConnection;10;1;3;1
WireConnection;13;0;12;0
WireConnection;13;1;3;2
WireConnection;0;0;7;0
WireConnection;0;1;8;0
WireConnection;0;3;10;0
WireConnection;0;4;13;0
WireConnection;0;5;16;0
ASEEND*/
//CHKSM=2ECEF5114B68A8B3E1A9D234E52EA056DB38615D