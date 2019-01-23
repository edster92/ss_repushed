using UnityEngine;
using System.Collections;

public class Mover : MonoBehaviour
{
	public float speed;
	public GameObject House;
	public float zMinBorder;
	public float zMaxBorder;
	private float currentZpos;

	void Start ()
	{
		currentZpos = transform.position.z;
	}

	void Update()
	{
		currentZpos += Time.deltaTime * speed;
		currentZpos = currentZpos <= zMinBorder ? zMaxBorder : currentZpos;
		House.transform.position = new Vector3 (House.transform.position.x, House.transform.position.y, currentZpos);
	}

}
