# Database Connection Test Design

## Overview

This design outlines the implementation of a comprehensive database connection test that verifies Supabase connectivity, creates a dedicated test table, and performs basic CRUD operations with timestamped test data. The test will integrate with the existing Vitest test suite and follow established patterns from the current Supabase error handling tests.

## Architecture

### Test Structure
The database connection test will be implemented as a new test file `src/lib/__tests__/supabase-connection.test.ts` that follows the existing test patterns and integrates with the current Supabase client configuration.

### Database Schema
A dedicated test table `test-only-test` will be created with the following structure:
- `id`: UUID primary key with auto-generation
- `message`: TEXT field to store test messages
- `created_at`: Timestamp with timezone for record creation
- `updated_at`: Timestamp with timezone for record updates

### Test Flow
1. **Connection Verification**: Test basic Supabase client connectivity
2. **Table Creation**: Ensure test table exists or create it
3. **Data Operations**: Insert/update test record with ISO timestamp
4. **Data Verification**: Read back and verify the test data

## Components and Interfaces

### Test File Structure
```typescript
// src/lib/__tests__/supabase-connection.test.ts
describe('Supabase Database Connection', () => {
  describe('Connection Verification', () => {
    // Test basic connectivity
  })
  
  describe('Test Table Management', () => {
    // Test table creation and existence
  })
  
  describe('Data Operations', () => {
    // Test insert/update operations with timestamps
  })
})
```

### Database Operations Interface
The test will use the existing `supabase` client from `src/lib/supabase.ts` and leverage the error handling utilities from `src/lib/supabase-errors.ts`.

### Test Table Schema
```sql
CREATE TABLE IF NOT EXISTS public."test-only-test" (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

## Data Models

### Test Record Interface
```typescript
interface TestRecord {
  id: string
  message: string
  created_at: string
  updated_at: string
}
```

### Test Message Format
The test message will follow the format: `"Hi, test successfully at ${new Date().toISOString()}"`

## Error Handling

### Connection Errors
- Network connectivity issues
- Authentication failures
- Invalid Supabase configuration

### Database Operation Errors
- Table creation failures
- Insert/update operation failures
- Permission or RLS policy issues

### Error Handling Strategy
The test will use the existing error handling utilities from `supabase-errors.ts` to provide meaningful error messages and proper error categorization.

## Testing Strategy

### Test Categories

#### Unit Tests
1. **Connection Test**: Verify basic Supabase client connectivity
2. **Table Creation Test**: Ensure test table can be created or accessed
3. **Insert Operation Test**: Verify data can be inserted with proper timestamp
4. **Update Operation Test**: Verify existing data can be updated with new timestamp
5. **Read Operation Test**: Verify data can be read back and validated

#### Integration Considerations
- The test will run against the actual Supabase instance configured in environment variables
- Test data will be isolated in the dedicated `test-only-test` table
- Tests will be idempotent and can run multiple times safely

### Test Environment
- Uses existing Vitest configuration
- Leverages existing Supabase client setup
- Follows existing test patterns for consistency

### Assertions and Validation
- Verify successful database connections
- Validate table creation or existence
- Confirm data insertion/update operations
- Verify timestamp format in ISO 8601 format
- Ensure test messages contain expected content

## Implementation Approach

### Phase 1: Basic Connection Test
Implement basic connectivity verification using the existing Supabase client.

### Phase 2: Table Management
Add functionality to create or verify the existence of the test table.

### Phase 3: Data Operations
Implement insert/update operations with timestamped test messages.

### Phase 4: Integration and Validation
Integrate with existing test suite and add comprehensive assertions.

## Technical Considerations

### Database Permissions
The test table will be created in the public schema and may need appropriate RLS policies if security is enabled.

### Test Data Cleanup
The test will use a single record that gets updated on each run, minimizing test data accumulation.

### Environment Dependencies
The test requires valid Supabase environment variables (`VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`) to be configured.

### Concurrency
The test uses a single test record with a known identifier to avoid conflicts in concurrent test runs.