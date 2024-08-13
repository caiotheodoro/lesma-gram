
CREATE TABLE users (
    id TEXT PRIMARY KEY  DEFAULT gen_random_uuid(),
    name TEXT,
    email TEXT NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    image TEXT,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT,
    FOREIGN KEY ("userId") REFERENCES users(id) ON DELETE CASCADE
);



CREATE TABLE likes (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "postId" TEXT NOT NULL,
    "userId" TEXT ,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("postId") REFERENCES posts(id) ON DELETE CASCADE,
    FOREIGN KEY ("userId") REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE user_settings (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid(),
    "userId" TEXT NOT NULL,
    "isAnonymous" BOOLEAN DEFAULT FALSE,
    "showPicture" BOOLEAN DEFAULT TRUE,
    "storyPosts" BOOLEAN DEFAULT FALSE,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("userId") REFERENCES users(id) ON DELETE CASCADE
);


INSERT INTO "posts" values ('sdsd','https://fastly.picsum.photos/id/34/200/300.jpg?hmac=K076uH4zC5xneqvhRayjS90G00xjPsR7eL_ShGEr6rs')
