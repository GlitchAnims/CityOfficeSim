extends Node

func aabb_intersects_rect(aabb: AABB, rect: Rect2, cam: Camera3D) -> bool:
	var frustum = get_frustum(Rect2(rect.position, rect.size), cam)
	return aabb_intersects_frustum(frustum, aabb)

func aabb_intersects_frustum(frustum: Array, box: AABB) -> bool:
	var mins = box.position
	var maxs = box.position + box.size
	
	var result = true # inside
	var vmin: Vector3
	var vmax: Vector3 
	var n: Vector3

	for i in frustum.size():
		if frustum[i].x > 0:
			vmin.x = mins.x
			vmax.x = maxs.x;
		else:
			vmin.x = maxs.x
			vmax.x = mins.x

		if frustum[i].y > 0: 
			vmin.y = mins.y
			vmax.y = maxs.y
		else:
			vmin.y = maxs.y
			vmax.y = mins.y

		if frustum[i].z > 0:
			vmin.z = mins.z
			vmax.z = maxs.z
		else:
			vmin.z = maxs.z
			vmax.z = mins.z
			
		n = Vector3(frustum[i].x, frustum[i].y, frustum[i].z)
		if n.dot(vmin) + frustum[i].w > 0:
			return false # outside; 
		if n.dot(vmax) + frustum[i].w >= 0: 
			result = true # intersects; 
		
	return result;


func get_frustum(rect: Rect2, cam: Camera3D) -> Array:
	var pnear = project_rect(rect, cam, cam.near+1)
	var pfar = project_rect(rect, cam, cam.far-1)
	var frustum = []
	frustum.resize(6)
	frustum[0] = plane(pnear[0], pnear[1], pnear[2]) # near
	frustum[1] = plane(pfar[2], pfar[1], pfar[0]) # far
	frustum[2] = plane(pfar[0], pnear[0], pnear[3]) # left
	frustum[3] = plane(pnear[2], pnear[1], pfar[1] ) # right
	frustum[4] = plane(pnear[1], pnear[0], pfar[0]) # top
	frustum[5] = plane(pnear[3], pnear[2], pfar[2]) # bottom
	return frustum
	

func project_rect(rect: Rect2, cam: Camera3D, z: float) -> PackedVector3Array:
	var p = PackedVector3Array()
	p.resize(4)
	p[0] = cam.project_position(rect.position, z)
	p[1] = cam.project_position(rect.position + Vector2(rect.size.x, 0.0), z)
	p[2] = cam.project_position(rect.position + Vector2(rect.size.x, rect.size.y), z)
	p[3] = cam.project_position(rect.position + Vector2(0.0, rect.size.y), z)
	return p

func plane(p1: Vector3, p2: Vector3, p3: Vector3) -> Vector4:
	var n = (p1-p2).cross((p3-p2)).normalized()
	var d = -p1.x * n.x - p1.y * n.y - p1.z * n.z 
	return Vector4(n.x, n.y, n.z, d)
