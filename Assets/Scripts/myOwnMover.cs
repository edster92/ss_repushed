using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class myOwnMover : MonoBehaviour
{
    public float speed;
	[SerializeField]
	bool randSpeed = false;
    private float CurPosition;
	[SerializeField]
	float minSpeed, maxSpeed;


    private void Start()
    {
        CurPosition = transform.position.z;
    }

    void Update ()
	{
		if (randSpeed) {
			CurPosition += Time.deltaTime * Random.Range (minSpeed,maxSpeed);
			transform.position = new Vector3 (transform.position.x, transform.position.y, CurPosition);
		} 
		else 
		{
			CurPosition += Time.deltaTime * speed;
			transform.position = new Vector3 (transform.position.x, transform.position.y, CurPosition);
		}

	}


}
