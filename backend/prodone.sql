-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('resident', 'government', 'contractor')),
    area_code VARCHAR(50) NOT NULL,
    avatar_url VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Projects table
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) NOT NULL CHECK (status IN ('commissioned', 'ongoing', 'completed', 'delayed')),
    location VARCHAR(255) NOT NULL,
    area_code VARCHAR(50) NOT NULL,
    budget DECIMAL(15, 2),
    start_date DATE,
    end_date DATE,
    contractor_id UUID REFERENCES users(id),
    agency_id UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Posts table
CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content TEXT NOT NULL,
    user_id UUID REFERENCES users(id) NOT NULL,
    project_id UUID REFERENCES projects(id) NOT NULL,
    post_type VARCHAR(20) NOT NULL CHECK (post_type IN ('update', 'complaint', 'question', 'announcement')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Media table for posts
CREATE TABLE media (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    post_id UUID REFERENCES posts(id) ON DELETE CASCADE,
    media_type VARCHAR(20) NOT NULL CHECK (media_type IN ('image', 'video', 'document')),
    url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Comments table
CREATE TABLE comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    content TEXT NOT NULL,
    user_id UUID REFERENCES users(id) NOT NULL,
    post_id UUID REFERENCES posts(id) NOT NULL,
    parent_comment_id UUID REFERENCES comments(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Chat rooms table
CREATE TABLE chat_rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Chat participants table
CREATE TABLE chat_participants (
    chat_room_id UUID REFERENCES chat_rooms(id) NOT NULL,
    user_id UUID REFERENCES users(id) NOT NULL,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (chat_room_id, user_id)
);

-- Messages table
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_room_id UUID REFERENCES chat_rooms(id) NOT NULL,
    user_id UUID REFERENCES users(id) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP WITH TIME ZONE
);

-- Tags table
CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Project tags junction table
CREATE TABLE project_tags (
    project_id UUID REFERENCES projects(id) NOT NULL,
    tag_id UUID REFERENCES tags(id) NOT NULL,
    PRIMARY KEY (project_id, tag_id)
);

-- Create indexes for better query performance
CREATE INDEX idx_users_area_code ON users(area_code);
CREATE INDEX idx_projects_area_code ON projects(area_code);
CREATE INDEX idx_posts_project_id ON posts(project_id);
CREATE INDEX idx_comments_post_id ON comments(post_id);
CREATE INDEX idx_messages_chat_room_id ON messages(chat_room_id);