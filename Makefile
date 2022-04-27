image_build:
	docker build -t book_notes/server .

start:
	docker run book_notes/server

stop:
	docker stop book_notes/server

test_unit:
	dart test test/unit

test_integration:
	dart test test/integration