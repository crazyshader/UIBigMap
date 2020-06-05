using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapTest : MonoBehaviour
{
	private int _blockIndex = 0;
	private BigMap _bigMap = null;

    // Start is called before the first frame update
    void Start()
    {
		_bigMap = gameObject.GetComponent<BigMap>();
    }

    // Update is called once per frame
    public void ChangeBlockIndex()
    {
		_bigMap.BlockSelectIndex = (_blockIndex++) % 9;
	}
}
