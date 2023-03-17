-- Generate with db_get
-- Author Toolf

CREATE TABLE "Book" (
  "bookId" bigint generated always as identity,
  "title" varchar(64) NOT NULL,
  "description" varchar NOT NULL,
  "createAt" timestamptz NOT NULL DEFAULT NOW(),
  "updateAt" timestamptz NOT NULL DEFAULT NOW()
);

ALTER TABLE "Book" ADD CONSTRAINT "pkBook" PRIMARY KEY ("bookId");

CREATE OR REPLACE FUNCTION book_update()
RETURNS TRIGGER AS $$
BEGIN
  NEW."updateAt" = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Book_updateAt_trigger
BEFORE UPDATE ON "Book"
FOR EACH ROW
EXECUTE PROCEDURE book_update();

CREATE TABLE "Character" (
  "characterId" bigint generated always as identity,
  "name" varchar(64) NOT NULL,
  "description" varchar NOT NULL,
  "bookId" bigint NOT NULL
);

ALTER TABLE "Character" ADD CONSTRAINT "pkCharacter" PRIMARY KEY ("characterId");
ALTER TABLE "Character" ADD CONSTRAINT "fkCharacterBook" FOREIGN KEY ("bookId") REFERENCES "Book" ("bookId");

CREATE TABLE "Action" (
  "actionId" bigint generated always as identity,
  "title" varchar(64) NOT NULL,
  "description" varchar NOT NULL,
  "bookId" bigint NOT NULL
);

ALTER TABLE "Action" ADD CONSTRAINT "pkAction" PRIMARY KEY ("actionId");
ALTER TABLE "Action" ADD CONSTRAINT "fkActionBook" FOREIGN KEY ("bookId") REFERENCES "Book" ("bookId");

CREATE TABLE "CharacterAction" (
  "characterId" bigint NOT NULL,
  "actionId" bigint NOT NULL
);

ALTER TABLE "CharacterAction" ADD CONSTRAINT "pkCharacterAction" PRIMARY KEY ("characterId", "actionId");
ALTER TABLE "CharacterAction" ADD CONSTRAINT "fkCharacterActionCharacter" FOREIGN KEY ("characterId") REFERENCES "Character" ("characterId");
ALTER TABLE "CharacterAction" ADD CONSTRAINT "fkCharacterActionAction" FOREIGN KEY ("actionId") REFERENCES "Action" ("actionId");

CREATE TABLE "Relationship" (
  "relationshipId" bigint generated always as identity,
  "fromCharacterId" bigint NOT NULL,
  "toCharacterId" bigint NOT NULL,
  "description" varchar(512) NOT NULL,
  "actionId" bigint NOT NULL
);

ALTER TABLE "Relationship" ADD CONSTRAINT "pkRelationship" PRIMARY KEY ("relationshipId");
ALTER TABLE "Relationship" ADD CONSTRAINT "fkRelationshipCharacter-characterFrom" FOREIGN KEY ("fromCharacterId") REFERENCES "Character" ("characterId");
ALTER TABLE "Relationship" ADD CONSTRAINT "fkRelationshipCharacter-characterTo" FOREIGN KEY ("toCharacterId") REFERENCES "Character" ("characterId");
ALTER TABLE "Relationship" ADD CONSTRAINT "fkRelationshipAction" FOREIGN KEY ("actionId") REFERENCES "Action" ("actionId");

CREATE TABLE "Note" (
  "noteId" bigint generated always as identity,
  "text" varchar(512) NOT NULL,
  "actionId" bigint NOT NULL
);

ALTER TABLE "Note" ADD CONSTRAINT "pkNote" PRIMARY KEY ("noteId");
ALTER TABLE "Note" ADD CONSTRAINT "fkNoteAction" FOREIGN KEY ("actionId") REFERENCES "Action" ("actionId")