private ["_trigger", "_grpArray", "_numGroups", "_infantryQueue", "_continue","_triggerStatements"];

_trigger = _this select 3;
_grpArray = _trigger getVariable ["GroupArray",[]];	
_numGroups = if ((count _this) > 6) then {_this select 6} else {1};

if ((count _grpArray) < _numGroups) then {
	if (isNil "A3EAI_staticInfantrySpawnQueue") then {
		A3EAI_staticInfantrySpawnQueue = [_this];
		_infantryQueue = [] spawn {
			//uiSleep 0.5;
			_continue = true;
			while {_continue} do {
				private ["_args","_trigger"];
				_args = (A3EAI_staticInfantrySpawnQueue select 0);
				_trigger = _args select 3;
				if (triggerActivated _trigger) then {
					_trigger setVariable ["isCleaning",false];
					_triggerStatements = (triggerStatements _trigger);
					_triggerStatements set [1,""];
					_trigger setTriggerStatements _triggerStatements;
					[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;
					0 = _args call A3EAI_spawnUnits_static;
					if ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled}) then {_nul = _trigger call A3EAI_addMapMarker;};
					uiSleep 3;
				};
				A3EAI_staticInfantrySpawnQueue deleteAt 0;
				_continue = !(A3EAI_staticInfantrySpawnQueue isEqualTo []);
			};
			A3EAI_staticInfantrySpawnQueue = nil;
		};
	} else {
		A3EAI_staticInfantrySpawnQueue pushBack _this;
	};
} else {
	private ["_triggerStatements"];
	_triggerStatements = (triggerStatements _trigger);
	_triggerStatements set [1,""];
	_trigger setTriggerStatements _triggerStatements;
	_trigger setTriggerArea [750,750,0,false];
	[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;
	if ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled}) then {
		_nul = _trigger call A3EAI_addMapMarker;
	};
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Maximum number of groups already spawned at %1. Exiting spawn script (spawnBandits)",(triggerText _trigger)];};
};

true