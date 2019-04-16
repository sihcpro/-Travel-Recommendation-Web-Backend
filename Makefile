reset-db:
	rails db:reset
	rails db:migrate
	rails db:seed
