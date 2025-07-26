-- Create test table for database connection testing
CREATE TABLE IF NOT EXISTS public."test-only-test" (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create trigger for updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_test_table_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER test_table_updated_at
    BEFORE UPDATE ON public."test-only-test"
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_test_table_updated_at();

-- Insert initial test record
INSERT INTO public."test-only-test" (message) 
VALUES ('Hi, test successfully at ' || NOW()::text)
ON CONFLICT DO NOTHING;