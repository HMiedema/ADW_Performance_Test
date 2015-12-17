--Report out
Select
	A.Run, A.Run_Number, A.Step, A.Action_Time AS Start_Time, B.Action_Time AS End_Time, B.Action_Time -A.Action_Time AS Duration, DateDiff(second, A.Action_Time, B.Action_Time) AS Duration_Seconds
FROM
	Results AS A
	INNER JOIN
	Results AS B
	ON
		A.Step = B.Step
		AND
		A.Step_Action = 'Start'
		AND
		B.Step_Action = 'End'
		AND
		A.Run = B.Run
		AND
		A.Run_Number = B.Run_number

ORDER BY
	4 desc