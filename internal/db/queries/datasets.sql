




-- name: DeleteDataset :exec
DELETE FROM datasets
WHERE id = $1;