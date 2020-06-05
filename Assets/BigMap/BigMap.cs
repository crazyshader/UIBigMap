using UnityEngine;

[ExecuteInEditMode]
public class BigMap : MonoBehaviour
{
	[SerializeField]
	private Material m_Material;

	[SerializeField]
	[Range(0, 8)]
	private int m_BlockSelectIndex;
	public int BlockSelectIndex { set { m_BlockSelectIndex = value; } }

	[SerializeField]
	[Range(0, 1)]
	private int[] m_BlockHighlightList = new int[9];
	private float[] m_BlockHighlights = new float[9];

	[SerializeField]
	private Color[] m_BlockColorList = new Color[9];
	private Vector4[] m_BlockColors = new Vector4[9];

	private Renderer m_MeshRenderer;
	private MaterialPropertyBlock m_MaterialPropertyBlock;
	private int m_BlockSelectIndexID;
	private int m_BlockHighlightsID;
	private int m_BlockColorsID;

	public void SetBlockHighlight(int index, bool enable)
	{
		m_BlockHighlightList[index] = enable ? 1 : 0;
		m_BlockHighlights[index] = m_BlockHighlightList[index];
	}

	private void ColorToVector(ref Color color, ref Vector4 vector)
	{
		vector.x = color.r;
		vector.y = color.g;
		vector.z = color.b;
		vector.w = color.a;
	}

	void Start()
	{
		m_MaterialPropertyBlock = new MaterialPropertyBlock();
		m_MeshRenderer = GetComponent<Renderer>();
		m_MeshRenderer?.GetPropertyBlock(m_MaterialPropertyBlock);

		m_BlockSelectIndexID = Shader.PropertyToID("_BlockSelectIndex");
		m_BlockHighlightsID = Shader.PropertyToID("_BlockHighlights");
		m_BlockColorsID = Shader.PropertyToID("_BlockColors");

		var length = m_BlockColorList.Length;
		for (int i = 0; i < length; ++i)
		{
			ColorToVector(ref m_BlockColorList[i], ref m_BlockColors[i]);
		}
	}

	void OnValidate()
	{
		var length = m_BlockHighlightList.Length;
		for (int i = 0; i < length; ++i)
		{
			SetBlockHighlight(i, m_BlockHighlightList[i] != 0);
		}
	}

	void Update()
	{
		//material?.SetInt("_BlockSelectIndex", blockSelectIndex);
		//material?.SetFloatArray("_BlockHighlights", blockHighlights);
		//material?.SetColorArray("_BlockColors", blockColors);

		m_MaterialPropertyBlock?.SetInt(m_BlockSelectIndexID, m_BlockSelectIndex);
		m_MaterialPropertyBlock?.SetFloatArray(m_BlockHighlightsID, m_BlockHighlights);
		m_MaterialPropertyBlock?.SetVectorArray(m_BlockColorsID, m_BlockColors);
		m_MeshRenderer?.SetPropertyBlock(m_MaterialPropertyBlock);
	}
}
