extends Node3D

@export var scale_offset: Node3D

@export var lower_body: Node3D

@export var eye_closed: Node3D
@export var eye_open: Node3D
@export var eye_X: Node3D

# ARMS
@export var arm_parent: Node3D

@export var shoulder_L: Node3D
@export var elbow_L: Node3D

@export var shoulder_R: Node3D
@export var elbow_R: Node3D

# LEGS
@export var ankle_L: Node3D
@export var knee_L: Node3D

@export var ankle_R: Node3D
@export var knee_R: Node3D

# UPPER BODY
@export var upper_body: Node3D

@export var torso_parent: Node3D
@export var skirt_parent: Node3D

@export var tail_parent: Node3D

@export var head: Node3D

@export var eyes: Node3D

@export var ear_L: Node3D
@export var ear_R: Node3D

@export var hair_front: Node3D

@export var hair_middle: Node3D

@export var hair_middle_back: Node3D

var scale_amplitude: float = 0.015
var arm_rot_amplitude: float = deg_to_rad(2.5)
var elbow_rot_amplitude: float = deg_to_rad(2.5)
var ankle_rot_amplitude: float = deg_to_rad(1.5)
var knee_rot_amplitude: float = deg_to_rad(5)

# Controls for snappy timing
var speed_min_factor: float = 0.6    # slowest multiplier (must be > 0)
var speed_max_factor: float = 1.6    # fastest multiplier
var speed_snap_pow: float = 1.5      # >1 sharpens peak, <1 flattens it


var curr_animation_value: float = 0.0
var animation_progress_per_sec: float = (130.0 / 60.0) / 2.0
const phase_offset: float = 0.175 * (2.0 * PI)

var unwrapped_animation_value: float = 0.0

func _ready() -> void:
	eye_closed.visible = false
	eye_open.visible = true
	eye_X.visible = false
	

func _process(delta: float) -> void:
	curr_animation_value = fposmod(curr_animation_value, 1.0) 
	
	var curr_rotation = curr_animation_value * PI * 2.0
	# ==========================================================================================================
	# AI GENERATED CURR ROTATION SPEED SNAPPINESS RELATED CODE

	# --- snappy curr_rotation update ---
	# compute a smooth signal that is 1 at curr_rotation == 0 or PI, 0 at PI/2 and 3PI/2
	var phase_signal: float = (1.0 + sin(curr_rotation * 1.0)) * 0.5   # in [0,1]

	# optionally sharpen the peaks (makes the "snap" more pronounced)
	var shaped_signal: float = pow(phase_signal, speed_snap_pow)

	# map shaped_signal into a speed factor between min and max
	var speed_factor: float = lerp(speed_min_factor, speed_max_factor, shaped_signal)
	
	curr_animation_value += (animation_progress_per_sec * delta * speed_factor)
	unwrapped_animation_value += (animation_progress_per_sec * delta * speed_factor)
	
	# keep curr_rotation in range
	curr_rotation = wrapf(curr_rotation, 0, (2.0 * PI))
	# ==========================================================================================================
	
	#if int(unwrapped_animation_value) > 13:
		#eye_X.visible = false
		#eye_open.visible = true
		#eye_closed.visible = false
	
	# animation ends at beat 15
	if int(unwrapped_animation_value - phase_offset) > 14:
		get_tree().quit()
	
	if int(unwrapped_animation_value) > 11:
		eye_X.visible = false
		eye_open.visible = false
		eye_closed.visible = true
	
	elif int(unwrapped_animation_value) > 7:
		eye_X.visible = false
		eye_open.visible = true
		eye_closed.visible = false
	
	elif int(unwrapped_animation_value) > 3:
		eye_X.visible = true
		eye_open.visible = false
		eye_closed.visible = false
	
	elif int(unwrapped_animation_value) > 0:
		eye_X.visible = false
		eye_open.visible = true
		eye_closed.visible = false
	
	
	scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * 1.2, true)
	scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * 1.2, true)
	
	#position.y = solve_cos(curr_rotation, .05, false)
	
	lower_body.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * 2, true)
	lower_body.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * 2, true)
	
	#arm_parent.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * 0.75, true)
	#arm_parent.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * 0.75, true)
	
	shoulder_L.rotation.z = solve_cos(curr_rotation, arm_rot_amplitude, true)
	shoulder_R.rotation.z = solve_cos(curr_rotation + PI, arm_rot_amplitude, false)
	
	elbow_L.rotation.z = solve_cos(curr_rotation, elbow_rot_amplitude, true)
	elbow_R.rotation.z = solve_cos(curr_rotation + PI, elbow_rot_amplitude, false)


	ankle_L.rotation.z = solve_cos(curr_rotation, ankle_rot_amplitude, true)
	knee_L.rotation.z = solve_cos(curr_rotation + PI, knee_rot_amplitude, false)
	
	ankle_R.rotation.z = solve_cos(curr_rotation + PI, ankle_rot_amplitude, false)
	knee_R.rotation.z = solve_cos(curr_rotation, knee_rot_amplitude, true)
	
	upper_body.position.y = solve_cos(curr_rotation, .4, false)
	
	torso_parent.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * 3, true)
	torso_parent.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * 3, true)
	
	torso_parent.position.y = 4.087 - solve_cos(curr_rotation, .05, false)
	
	skirt_parent.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude, false)
	skirt_parent.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude, false)
	
	
	var tail_rot: float = deg_to_rad(25)
	tail_parent.rotation.z = solve_cos(curr_rotation, tail_rot, true) + solve_cos(curr_rotation, tail_rot, false)
	tail_parent.scale.x = solve_cos(curr_rotation, 0.5, true) + solve_cos(curr_rotation, 0.5, false)
	
	
	head.position.y = solve_cos(curr_rotation, .05, true)
	
	eyes.scale.x = 1.0 + solve_cos(curr_rotation, scale_amplitude * 5., true)
	eyes.scale.y = 1.0 - solve_cos(curr_rotation, scale_amplitude * 5., true)
	
	ear_L.rotation.z = solve_cos(curr_rotation, deg_to_rad(5), true)
	ear_R.rotation.z = solve_cos(curr_rotation, deg_to_rad(5), true) * -1.
	
	ear_L.position.y = 8.502 + solve_cos(curr_rotation, .125, true)
	ear_R.position.y = 8.502 + solve_cos(curr_rotation, .125, true)
	
	ear_L.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * .5, true)
	ear_L.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * .5, true)
	ear_R.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * .5, true)
	ear_R.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * .5, true)
	
	
	hair_front.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * 2., true)
	hair_front.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * 2., true)
	
	hair_front.position.y = 7.402 - solve_cos(curr_rotation, .08, true)
	
	
	hair_middle.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * 2., true, PI/6)
	hair_middle.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * 2., true, PI/6)
	
	hair_middle.position.y = 8.221 - solve_cos(curr_rotation, .04, true, PI/6)
	
	
	hair_middle_back.scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude * 2., true, PI/4)
	hair_middle_back.scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude * 2., true, PI/4)
	
	hair_middle_back.position.y = 8.562 - solve_cos(curr_rotation, .01, true, PI/4)
	
	
	

func solve_cos(curr_rotation: float, amplitude: float, direction: bool = true, phase: float = 0.0) -> float:
	var solved_cos: float = cos(curr_rotation + phase + phase_offset) * amplitude * -1.0
	if direction:
		solved_cos -= amplitude
	else:
		solved_cos += amplitude
	return solved_cos
